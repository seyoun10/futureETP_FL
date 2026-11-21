// 계약 테스트(D-142, FL-007, FL-017).
// fixtures/*.json은 로컬 dev 서버의 실제 응답 data(차트 두 개는 마지막 60거래일만 남김).
// calendar.json만 서버 테스트(`apps/server/src/api/calendar.test.ts`) 값에 예외 종류·missing을 더해 손으로 만들었다.
// 각 fixture가 계약 JSON Schema를 통과하고, 모델로 디코딩되고, 모델의 toJson이 원래 JSON과 같은지 본다.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/health.dart';
import 'package:futureetp/core/api/models/calendar.dart';
import 'package:futureetp/core/api/models/commodities.dart';
import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/api/models/curve.dart';
import 'package:futureetp/core/api/models/device.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/etp.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:json_schema/json_schema.dart';

const _schemaDir = 'test/contract/schemas';
const _upstreamDir = '../futureETP/packages/shared/contract';

Object? _readJson(String path) => jsonDecode(File(path).readAsStringSync());

JsonSchema _schema(String name) =>
    JsonSchema.create(_readJson('$_schemaDir/$name.json')!);

void _expectValid(String schemaName, Object? instance) {
  final result = _schema(schemaName).validate(instance, validateFormats: true);
  expect(result.isValid, isTrue, reason: result.errors.join('\n'));
}

/// 응답 스키마 이름 → (fixture 디코딩, 모델 → JSON). health는 손 작성 모델이라 toJson이 없다.
final _responses = <String, Object? Function(Map<String, dynamic>)>{
  'commodities': (j) => CommodityList.fromJson(j).toJson(),
  'disparityChart': (j) => DisparityChart.fromJson(j).toJson(),
  'curve': (j) => Curve.fromJson(j).toJson(),
  'contractsChart': (j) => ContractsChart.fromJson(j).toJson(),
  'etpList': (j) => EtpList.fromJson(j).toJson(),
  'etpDetail': (j) => EtpDetail.fromJson(j).toJson(),
  'settings': (j) => DeviceSettings.fromJson(j).toJson(),
  'device': (j) => Device.fromJson(j).toJson(),
  'calendar': (j) => MarketCalendar.fromJson(j).toJson(),
};

void main() {
  group('응답 fixture', () {
    test('스키마 검사기가 어긋난 값을 거절한다', () {
      final json =
          _readJson('test/contract/fixtures/settings.json')!
              as Map<String, dynamic>;
      for (final bad in [
        {...json}..remove('timezone'),
        {...json, 'basis': 'XX'},
        {
          ...json,
          'rareLevels': [1, 2],
        },
      ]) {
        expect(_schema('settings').validate(bad).isValid, isFalse);
      }
    });

    test('health', () {
      final json = _readJson('test/contract/fixtures/health.json');
      _expectValid('health', json);
      expect(Health.fromJson(json).status, 'ok');
    });

    for (final MapEntry(key: name, value: roundTrip) in _responses.entries) {
      test(name, () {
        final json =
            _readJson('test/contract/fixtures/$name.json')!
                as Map<String, dynamic>;
        _expectValid(name, json);
        final back = jsonDecode(jsonEncode(roundTrip(json)));
        // 모델이 필드를 빠뜨리거나 값을 바꾸지 않는다
        expect(back, equals(json));
        // 모델에서 만든 JSON도 스키마를 통과한다
        _expectValid(name, back);
      });
    }
  });

  group('요청 본문', () {
    test('SettingsPatch는 준 필드만 보내고 PatchValue(null)은 null로 보낸다', () {
      const patch = SettingsPatch(
        locale: AppLanguage.en,
        basis: Basis.kr,
        maPeriod: MaPeriod.ma200,
        window: DistributionWindow.all,
        rareLevels: [1, 2, 4, 8, 16],
        alertCommodity: PatchValue(null),
        quietTime: PatchValue(QuietTime(startMin: 1380, endMin: 420)),
      );
      final json = patch.toJson();
      expect(json, {
        'locale': 'en',
        'basis': 'KR',
        'maPeriod': 200,
        'window': 'ALL',
        'rareLevels': [1, 2, 4, 8, 16],
        'alertCommodity': null,
        'quietTime': {'startMin': 1380, 'endMin': 420},
      });
      _expectValid('settingsPatch', json);
      expect(const SettingsPatch(timezone: 'Asia/Seoul').toJson(), {
        'timezone': 'Asia/Seoul',
      });
      expect(
        const SettingsPatch(alertCommodity: PatchValue(CommodityCode.ng))
            .toJson(),
        {'alertCommodity': 'NG'},
      );
    });

    test('DeviceRegistration', () {
      final json = const DeviceRegistration(
        pushToken: null,
        platform: DevicePlatform.ios,
        appVersion: 'fl-1.0.0',
      ).toJson();
      expect(json, {
        'pushToken': null,
        'platform': 'IOS',
        'appVersion': 'fl-1.0.0',
      });
      _expectValid('deviceRegistration', json);
    });
  });

  group('enum 값은 계약과 같다', () {
    Set<Object?> contractEnum(String schema, List<String> path) {
      var node = _readJson('$_schemaDir/$schema.json');
      for (final key in path) {
        node = (node! as Map<String, dynamic>)[key];
      }
      return ((node! as Map<String, dynamic>)['enum'] as List).toSet();
    }

    test('설정 enum', () {
      expect(
        Basis.values.map((v) => SettingsPatch(basis: v).toJson()['basis']),
        unorderedEquals(contractEnum('settings', ['properties', 'basis'])),
      );
      expect(
        MaPeriod.values.map(
          (v) => SettingsPatch(maPeriod: v).toJson()['maPeriod'],
        ),
        unorderedEquals(contractEnum('settings', ['properties', 'maPeriod'])),
      );
      expect(
        DistributionWindow.values.map(
          (v) => SettingsPatch(window: v).toJson()['window'],
        ),
        unorderedEquals(contractEnum('settings', ['properties', 'window'])),
      );
      expect(
        CommodityCode.values.map((v) => v.wire),
        unorderedEquals(
          ((_readJson('$_schemaDir/api.json')! as Map)['pathParams']
                  as Map)['code']
              as List,
        ),
      );
    });

    test('달력 enum', () {
      const exception = ['properties', 'exceptions', 'items', 'properties'];
      expect(
        CalendarMarket.values.map(
          (v) => CalendarMissing(market: v, year: 2027).toJson()['market'],
        ),
        unorderedEquals(contractEnum('calendar', [...exception, 'market'])),
      );
      expect(
        CalendarExceptionKind.values.map(
          (v) => CalendarException(
            market: CalendarMarket.cme,
            date: '2026-11-26',
            kind: v,
            at: null,
            note: '',
          ).toJson()['kind'],
        ),
        unorderedEquals(contractEnum('calendar', [...exception, 'kind'])),
      );
    });

    test('모르는 enum 값은 디코딩 실패', () {
      final json =
          _readJson('test/contract/fixtures/settings.json')!
              as Map<String, dynamic>;
      expect(
        () => DeviceSettings.fromJson({...json, 'basis': 'XX'}),
        throwsArgumentError,
      );
    });
  });

  test(
    '복사한 계약이 원본과 같다(다르면 ./tool/sync_contract.sh)',
    () {
      final upstream = Directory('$_upstreamDir/schemas');
      final files = [
        File('$_upstreamDir/api.json'),
        ...upstream.listSync().whereType<File>(),
      ];
      final copied = Directory(_schemaDir).listSync().whereType<File>();
      expect(
        copied.map((f) => f.uri.pathSegments.last).toSet(),
        files.map((f) => f.uri.pathSegments.last).toSet(),
      );
      for (final file in files) {
        final name = file.uri.pathSegments.last;
        expect(
          File('$_schemaDir/$name').readAsStringSync(),
          file.readAsStringSync(),
          reason: name,
        );
      }
    },
    // CI에는 원본 저장소가 없다
    skip: Directory(_upstreamDir).existsSync() ? false : '원본 저장소 없음',
  );
}
