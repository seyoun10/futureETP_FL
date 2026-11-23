import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_provider.dart';

import '../../../helpers/fake_http.dart';

Map<String, Object?> _fixture(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync())
        as Map<String, Object?>;

/// 이전 3년 응답: fixture 봉 3개를 2023년 날짜로 바꾼 것, 더 받을 것 없음.
Map<String, Object?> _olderPage() {
  final page = _fixture('disparityChart');
  final bars = (page['bars']! as List).take(3).toList();
  return {
    ...page,
    'bars': [
      for (final (i, bar) in bars.indexed)
        {...bar as Map<String, Object?>, 'tradeDate': '2023-01-0${i + 3}'},
    ],
    'hasMore': false,
  };
}

late Map<String, Object?> _settings;
late List<RequestOptions> _chartRequests;

/// 과거·최근 응답 지연(진행 중인 받기와 다시 조회가 겹치는 경우).
Duration? _olderDelay;
Duration? _latestDelay;

ProviderContainer _container() {
  _chartRequests = [];
  final adapter = FakeHttpAdapter((req) {
    if (req.path == '/settings') return FakeResponse.ok(_settings);
    _chartRequests.add(req);
    return req.queryParameters.containsKey('before')
        ? FakeResponse.ok(_olderPage(), delay: _olderDelay)
        : FakeResponse.ok(_fixture('disparityChart'), delay: _latestDelay);
  });
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      apiClientProvider.overrideWithValue(
        ApiClient(
          Dio(BaseOptions(baseUrl: 'http://test/v1'))
            ..httpClientAdapter = adapter,
          accessToken: () async => 'key',
          deviceId: () async => 'id',
        ),
      ),
    ],
  );
  addTearDown(c.dispose);
  // 화면처럼 듣고 있는 상태로 둔다
  c.listen(_gc, (_, _) {});
  return c;
}

final AsyncNotifierProvider<DisparityChartNotifier, DisparityData> _gc =
    disparityChartProvider(CommodityCode.gc);

void main() {
  setUp(() {
    _settings = _fixture('settings');
    _olderDelay = null;
    _latestDelay = null;
  });

  test('기기 설정 값으로 최근 3년을 받는다', () async {
    final c = _container();
    final data = await c.read(_gc.future);
    expect(_chartRequests.single.path, '/commodities/GC/disparity');
    expect(_chartRequests.single.queryParameters, {
      'basis': 'FRONT',
      'ma': '100',
      'window': 'Y10',
      'levels': '1,2,4,8,16',
    });
    expect(data.chart.bars, hasLength(60));
  });

  test('이전 3년은 가장 이른 봉 전으로 받아 앞에 붙이고, 더 없으면 받지 않는다', () async {
    final c = _container();
    await c.read(_gc.future);
    await c.read(_gc.notifier).loadOlder();

    expect(_chartRequests.last.queryParameters['before'], '2026-08-07');
    final chart = c.read(_gc).requireValue.chart;
    expect(chart.bars, hasLength(63));
    expect(chart.bars.first.tradeDate, '2023-01-03');
    expect(chart.bars[3].tradeDate, '2026-08-07');
    expect(chart.hasMore, isFalse);

    await c.read(_gc.notifier).loadOlder();
    expect(_chartRequests, hasLength(2));
  });

  test('다시 조회하면 최근 3년만 받고 과거 봉은 이어 붙인다', () async {
    final c = _container();
    await c.read(_gc.future);
    await c.read(_gc.notifier).loadOlder();

    c.invalidate(_gc);
    final data = await c.read(_gc.future);
    expect(_chartRequests, hasLength(3));
    expect(_chartRequests.last.queryParameters.containsKey('before'), isFalse);
    expect(data.chart.bars, hasLength(63));
    expect(data.chart.hasMore, isFalse);
  });

  // RN dfa05cf: 자동 새로고침이 진행 중인 과거 받기를 취소하지 않는다
  for (final (name, older, latest) in [
    ('다시 조회가 먼저 끝나도', 50, 10),
    ('과거 받기가 먼저 끝나도', 10, 50),
  ]) {
    test('과거 받기 중 다시 조회해도 과거 봉이 남는다($name)', () async {
      final c = _container();
      await c.read(_gc.future);
      _olderDelay = Duration(milliseconds: older);
      _latestDelay = Duration(milliseconds: latest);

      final loading = c.read(_gc.notifier).loadOlder();
      c.invalidate(_gc);
      final refreshed = c.read(_gc.future);
      await Future.wait([loading, refreshed]);
      await Future<void>.delayed(Duration.zero);

      final chart = c.read(_gc).requireValue.chart;
      expect(chart.bars, hasLength(63));
      expect(chart.bars.first.tradeDate, '2023-01-03');
      expect(chart.hasMore, isFalse);
    });
  }

  test('조건(설정)이 바뀌면 과거 봉을 버리고 새로 받는다', () async {
    final c = _container();
    await c.read(_gc.future);
    await c.read(_gc.notifier).loadOlder();

    _settings = {..._settings, 'maPeriod': 200};
    c.invalidate(deviceSettingsProvider);
    await c.read(deviceSettingsProvider.future);
    final data = await c.read(_gc.future);
    expect(_chartRequests.last.queryParameters['ma'], '200');
    expect(data.chart.bars, hasLength(60));
    expect(data.chart.hasMore, isTrue);
  });

  test('설정을 다시 받아도 조건이 같으면 다시 조회하지 않는다', () async {
    final c = _container();
    await c.read(_gc.future);
    c.invalidate(deviceSettingsProvider);
    await c.read(deviceSettingsProvider.future);
    await c.read(_gc.future);
    expect(_chartRequests, hasLength(1));
  });
}
