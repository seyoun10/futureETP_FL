import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/features/commodity/etp/etp_list_tab.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/fake_http.dart';
import '../../../helpers/test_app.dart';

Map<String, Object?> _list() =>
    jsonDecode(File('test/contract/fixtures/etpList.json').readAsStringSync())
        as Map<String, Object?>;

late List<String> _opened;

Future<void> _pump(WidgetTester tester, Map<String, Object?> data) async {
  _opened = [];
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(
          ApiClient(
            Dio(BaseOptions(baseUrl: 'http://test/v1'))
              ..httpClientAdapter = FakeHttpAdapter.always(
                FakeResponse.ok(data),
              ),
            accessToken: () async => 'key',
            deviceId: () async => 'id',
          ),
        ),
      ],
      child: testApp(
        home: Scaffold(
          body: EtpListTab(codeText: 'GC', onOpenEtp: _opened.add),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// 목록 행의 [index]번째(0부터) 두 줄 글자.
List<String> _row(WidgetTester tester, int index) {
  final row = find
      .byWidgetPredicate(
        (w) =>
            w is InkWell &&
            (w.key as ValueKey<String>?)?.value.startsWith('etp-') == true,
      )
      .at(index);
  return [
    for (final t in tester.widgetList<Text>(
      find.descendant(of: row, matching: find.byType(Text)),
    ))
      t.data ?? '',
  ];
}

Future<void> _choose(WidgetTester tester, String control, String label) async {
  await tester.tap(
    find.descendant(of: find.byKey(Key(control)), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('필터는 상단 안전 영역만큼 띄우지 않고 탭 맨 위에서 시작한다', (tester) async {
    tester.view.padding = const FakeViewPadding(top: 186);
    addTearDown(tester.view.resetPadding);
    await _pump(tester, _list());
    expect(tester.getTopLeft(find.byKey(const Key('etp-list'))).dy, 0);
    expect(tester.getTopLeft(find.byKey(const Key('etp-filter-market'))).dy, 0);
  });

  testWidgets('기기 로캘이 한국어면 이름순에서 한글이 라틴보다 앞이다(RN localeCompare)', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('ko', 'KR');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    await _pump(tester, _list());
    expect(_row(tester, 0).first, '메리츠 솔랙티브 금 선물 ETN(H)');
    expect(_row(tester, 3).first, 'KODEX 골드선물(H)');
  });

  testWidgets('기본 정렬: KRX 먼저, 배수·이름순. 행을 누르면 그 ETP를 연다', (tester) async {
    await _pump(tester, _list());
    expect(_row(tester, 0), ['KODEX 골드선물(H)', 'KRX · ETF · 1x · Hedged']);
    expect(_row(tester, 1), ['TIGER 골드선물(H)', 'KRX · ETF · 1x · Hedged']);
    await tester.tap(find.text('KODEX 골드선물(H)'));
    expect(_opened, ['19876645-bd78-4a16-9857-388d7c6c4f64']);
  });

  testWidgets('시장 US로 거르면 티커 + 이름이고, 해당 없음 환헤지다', (tester) async {
    await _pump(tester, _list());
    await _choose(tester, 'etp-filter-market', 'US');
    expect(_row(tester, 0), [
      'DGP  PowerShares DB Gold Double Long ETN',
      'US · ETN · 2x · N/A',
    ]);
  });

  testWidgets('순자산 정렬은 시장 안에서 큰 순서이고 값을 붙인다', (tester) async {
    await _pump(tester, _list());
    await _choose(tester, 'etp-sort', 'AUM');
    expect(_row(tester, 0), [
      'KODEX 골드선물(H)',
      'KRX · ETF · 1x · Hedged · AUM ₩328.2B',
    ]);
    await _choose(tester, 'etp-filter-market', 'US');
    expect(_row(tester, 0), [
      'UGL  ProShares Ultra Gold',
      r'US · ETF · 2x · N/A · AUM $690.5M',
    ]);
  });

  testWidgets('배수 선택지는 받은 배수만이고, 맞는 상품이 없으면 안내한다', (tester) async {
    await _pump(tester, _list());
    final leverage = find.byKey(const Key('etp-filter-leverage'));
    for (final label in ['All', '1x', '2x', '-1x', '-2x']) {
      expect(
        find.descendant(of: leverage, matching: find.text(label)),
        findsOneWidget,
      );
    }
    await _choose(tester, 'etp-filter-market', 'US');
    await _choose(tester, 'etp-filter-leverage', '1x');
    expect(find.text('No products match the filters.'), findsOneWidget);
  });

  testWidgets('상품이 없으면 필터 없이 안내만 한다', (tester) async {
    await _pump(tester, {'asOf': null, 'etps': <Object>[]});
    expect(find.text('No ETPs for this commodity.'), findsOneWidget);
    expect(find.byKey(const Key('etp-sort')), findsNothing);
  });
}
