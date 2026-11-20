import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/commodity_list/commodity_list_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/fake_http.dart';
import '../../helpers/test_app.dart';

Map<String, Object?> _quote(
  String month, {
  double? price,
  double? change,
  double? pct,
  bool noTrade = false,
  bool front = false,
}) => {
  'symbol': 'X',
  'contractMonth': month,
  'price': price,
  'change': change,
  'changePct': pct,
  'noTrade': noTrade,
  'isFront': front,
};

/// GC 한 줄(오르는 월물·내리는 월물·변화 없음·거래 없음), NG는 알림 대상.
Map<String, Object?> _list({double gcPrice = 2418.2}) => {
  'freshness': {
    'asOf': '2026-10-22T00:00:00.000Z',
    'tradeDate': '2026-10-22',
    'delayed': true,
    'marketState': 'OPEN',
    'nextUpdateAt': null,
  },
  'commodities': [
    {
      'code': 'GC',
      'priceDecimals': 1,
      'alert': false,
      'contracts': [
        _quote('2026-12', price: gcPrice, change: 12.1, pct: 0.5, front: true),
        _quote('2027-02', price: 2431.7, change: -11.9, pct: -0.49),
        _quote('2027-04', price: 2445, change: 0.01, pct: 0.0004),
        _quote('2027-06', price: 2458.3, noTrade: true),
      ],
    },
    {
      'code': 'NG',
      'priceDecimals': 3,
      'alert': true,
      'contracts': [
        _quote('2026-12', price: 3.12, change: -0.031, pct: -0.98, front: true),
      ],
    },
  ],
};

final Map<String, Object?> _settings = jsonDecode(
  File('test/contract/fixtures/settings.json').readAsStringSync(),
) as Map<String, Object?>;

/// 목록 응답을 차례로 꺼낸다(다 쓰면 마지막 것을 되풀이).
late List<FakeResponse> _responses;
var _listCalls = 0;
String? _alertCommodity;

Future<void> _pump(WidgetTester tester) async {
  _listCalls = 0;
  final adapter = FakeHttpAdapter((req) {
    if (req.path == '/settings') {
      return FakeResponse.ok({..._settings, 'alertCommodity': _alertCommodity});
    }
    final i = _listCalls < _responses.length
        ? _listCalls
        : _responses.length - 1;
    _listCalls++;
    return _responses[i];
  });
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        upDownPaletteProvider.overrideWithValue(UpDownPalette.kr),
        apiClientProvider.overrideWithValue(
          ApiClient(
            Dio(BaseOptions(baseUrl: 'http://test/v1'))
              ..httpClientAdapter = adapter,
            accessToken: () async => 'key',
            deviceId: () async => 'id',
          ),
        ),
      ],
      child: testApp(
        home: CommodityListScreen(
          onOpenSettings: () {},
          onOpenCommodity: (_) {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Color? _color(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style?.color;

/// 햅틱 호출을 센다.
List<String> _haptics(WidgetTester tester) {
  final calls = <String>[];
  final messenger = tester.binding.defaultBinaryMessenger
    ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        calls.add('${call.arguments}');
      }
      return null;
    });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
  return calls;
}

Future<void> _pull(WidgetTester tester) async {
  await tester.fling(
    find.byKey(const Key('commodity-list')),
    const Offset(0, 300),
    1000,
  );
  // 인디케이터가 걸리고 onRefresh가 불릴 때까지
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

bool _blocked(WidgetTester tester) => tester
    .widget<AbsorbPointer>(
      find
          .ancestor(
            of: find.byType(Scaffold),
            matching: find.byType(AbsorbPointer),
          )
          .first,
    )
    .absorbing;

void main() {
  setUp(() {
    _responses = [FakeResponse.ok(_list())];
    _alertCommodity = 'GC';
  });

  testWidgets('원자재마다 이름·심볼과 월물 줄을 서버 순서대로 그린다', (tester) async {
    await _pump(tester);
    expect(find.text('Gold\n(GC)'), findsOneWidget);
    expect(find.text('Natural Gas\n(NG)'), findsOneWidget);
    // 대표월물 ●, 가격 자릿수
    expect(find.text('DEC26●'), findsNWidgets(2));
    expect(find.text('FEB27 '), findsOneWidget);
    expect(find.text('2,418.2'), findsOneWidget);
    expect(find.text('3.120'), findsOneWidget);
    // 등락 색(한국식): 상승 빨강·하락 파랑, 반올림해 0이면 방향 없는 색
    expect(_color(tester, '+12.1'), UpDownPalette.kr.up);
    expect(_color(tester, '+0.50%'), UpDownPalette.kr.up);
    expect(_color(tester, '-11.9'), UpDownPalette.kr.down);
    expect(_color(tester, '0.0'), UpDownPalette.kr.flat);
    // 거래 없음이면 변화량·등락률 대신 안내
    expect(find.text('No trade'), findsOneWidget);
    // 알림 대상은 NG만
    expect(find.text('🔔'), findsOneWidget);
    // 최하단 기준 시각 줄
    expect(find.textContaining('Trade date 10/22'), findsOneWidget);
    // 알림 대상이 있으면 [⚙]에 점이 없다
    expect(find.byKey(const Key('header-badge')), findsNothing);
  });

  testWidgets('알림 대상이 없으면 [⚙]에 빨간 점', (tester) async {
    _alertCommodity = null;
    await _pump(tester);
    expect(find.byKey(const Key('header-badge')), findsOneWidget);
  });

  testWidgets('알림 대상을 바꾸면 목록을 다시 받는다(D-124)', (tester) async {
    await _pump(tester);
    expect(_listCalls, 1);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(CommodityListScreen)),
    );
    _alertCommodity = 'NG';
    unawaited(
      container
          .read(deviceSettingsProvider.notifier)
          .save(
            const SettingsPatch(alertCommodity: PatchValue(CommodityCode.ng)),
          ),
    );
    await tester.pumpAndSettle();
    expect(_listCalls, 2);
  });

  testWidgets('당기면 햅틱, 끝날 때까지 터치를 막고 새 값으로 바꾼다', (tester) async {
    _responses = [
      FakeResponse.ok(_list()),
      FakeResponse.ok(_list(gcPrice: 2500), delay: const Duration(seconds: 2)),
    ];
    await _pump(tester);
    final haptics = _haptics(tester);
    await _pull(tester);
    expect(haptics, ['HapticFeedbackType.lightImpact']);
    expect(_blocked(tester), isTrue);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(_blocked(tester), isFalse);
    expect(find.text('2,500.0'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('5초 안에 안 끝나면 Alert를 띄우고, 늦게 온 응답은 목록을 바꾼다', (tester) async {
    _responses = [
      FakeResponse.ok(_list()),
      FakeResponse.ok(_list(gcPrice: 2500), delay: const Duration(seconds: 8)),
    ];
    await _pump(tester);
    await _pull(tester);
    await tester.pump(pullRefreshTimeout);
    await tester.pumpAndSettle();
    expect(find.text("Couldn't finish refreshing"), findsOneWidget);
    expect(_blocked(tester), isFalse);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    // [확인]은 다시 조회하지 않는다
    expect(_listCalls, 2);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('2,500.0'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('새로고침이 실패하면 Alert, 목록은 이전 값을 둔다', (tester) async {
    _responses = [FakeResponse.ok(_list()), FakeResponse.fail('INTERNAL', 500)];
    await _pump(tester);
    await _pull(tester);
    await tester.pumpAndSettle();
    expect(find.text('Pull down again in a moment.'), findsOneWidget);
    expect(find.text('2,418.2'), findsOneWidget);
  });
}
