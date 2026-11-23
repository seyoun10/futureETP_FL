import 'dart:ui' show SemanticsFlag;

import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/features/calendar/calendar_provider.dart';
import 'package:futureetp/features/calendar/calendar_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/fake_http.dart';
import '../../helpers/test_app.dart';

// screens.md A-a 그림과 같은 일정(시장 현지 값). 한국 기기에서 본다.
const List<Map<String, String?>> _exceptions = [
  {
    'market': 'CME',
    'date': '2026-11-26',
    'kind': 'HALT',
    'at': '13:30',
    'note': 'Thanksgiving Day',
  },
  {
    'market': 'NYSE',
    'date': '2026-11-26',
    'kind': 'CLOSED',
    'at': null,
    'note': 'Thanksgiving Day',
  },
  {
    'market': 'NYSE',
    'date': '2026-11-27',
    'kind': 'EARLY_CLOSE',
    'at': '13:00',
    'note': 'Day after Thanksgiving',
  },
  {
    'market': 'CME',
    'date': '2026-11-27',
    'kind': 'EARLY_CLOSE',
    'at': '13:45',
    'note': 'Day after Thanksgiving',
  },
];

Future<FakeHttpAdapter> _pump(
  WidgetTester tester, {
  required DateTime today,
  required List<Map<String, Object>> missing,
  Locale locale = const Locale('ko'),
}) async {
  tester.view
    ..physicalSize = const Size(420, 4000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final adapter = FakeHttpAdapter(
    (req) => FakeResponse.ok({
      'from': req.queryParameters['from'],
      'to': req.queryParameters['to'],
      'exceptions': _exceptions,
      'missing': missing,
    }),
  );
  final seoul = tz.getLocation('Asia/Seoul');
  await withClock(Clock.fixed(today), () async {
    await tester.pumpWidget(
      ProviderScope(
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
          calendarToLocalProvider.overrideWithValue(
            (instant) => tz.TZDateTime.from(instant, seoul),
          ),
        ],
        child: testApp(home: const CalendarScreen(), locale: locale),
      ),
    );
  });
  await tester.pumpAndSettle();
  return adapter;
}

Finder _rich(String text) => find.text(text, findRichText: true);

void main() {
  setUpAll(tz_data.initializeTimeZones);

  testWidgets('3개월 달력에 로컬 날짜로 옮긴 일정과 미입력 안내를 보인다', (tester) async {
    final adapter = await _pump(
      tester,
      today: DateTime(2026, 11, 21, 9),
      missing: [
        {'market': 'KRX', 'year': 2027},
      ],
    );
    // 범위를 앞뒤 하루씩 넓혀 받는다
    expect(adapter.requests.single.uri.queryParameters, {
      'from': '2026-10-31',
      'to': '2027-02-01',
    });
    expect(find.text('휴장 달력'), findsOneWidget);
    expect(find.text('2026년 11월'), findsOneWidget);
    expect(find.text('2026년 12월'), findsOneWidget);
    expect(find.text('2027년 1월'), findsOneWidget);
    expect(find.text('KRX 2027년 휴장 정보가 아직 없습니다'), findsOneWidget);

    // 목록은 로컬 시각순: 11/26 23:30 NYSE 개장, 11/27 04:30 CME 정지,
    // 11/28 03:00 NYSE 조기 마감, 04:45 CME 조기 마감
    final lines = tester
        .widgetList<RichText>(
          find.descendant(
            of: find.byKey(const ValueKey('calendar-month-2026-11')),
            matching: find.byType(RichText),
          ),
        )
        .map((r) => r.text.toPlainText())
        .where((t) => t.contains(' · '))
        .toList();
    expect(lines, [
      '휴장 · Thanksgiving Day',
      '휴장 (04:30 거래 중단) · Thanksgiving Day',
      '조기 마감 03:00 · Day after Thanksgiving',
      '조기 마감 04:45 · Day after Thanksgiving',
    ]);
    expect(find.text('11/26 (목)'), findsOneWidget);
    expect(find.text('11/28 (토)'), findsNWidgets(2));
    expect(find.text('휴장·단축 거래 없음'), findsNWidgets(2));

    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('calendar-day-2026-11-27')))
          .label,
      '11월 27일, CME 휴장 (04:30 거래 중단)',
    );
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('calendar-day-2026-11-21')))
          .label,
      '11월 21일, 오늘',
    );
    expect(_rich('휴장 · Thanksgiving Day'), findsOneWidget);
  });

  testWidgets('스크린 리더는 월 제목만 제목으로, 목록은 한 줄씩 읽는다', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester, today: DateTime(2026, 11, 21), missing: const []);
    // 제목에 요일·목록 문구가 합쳐지지 않는다
    expect(
      find.semantics
          .byFlag(SemanticsFlag.isHeader)
          .evaluate()
          .map((n) => n.label),
      containsAll(['2026년 11월', '2026년 12월', '2027년 1월']),
    );
    expect(
      find.semantics.byLabel('11/26 (목)\nNYSE\n휴장 · Thanksgiving Day'),
      findsOne,
    );
    expect(find.semantics.byLabel('월'), findsAtLeast(3));
    handle.dispose();
  });

  testWidgets('3개월 밖 연도의 미입력은 안내하지 않는다', (tester) async {
    // 10~12월을 보면 넓힌 끝(2027-01-01)이 다음 해에 걸린다
    await _pump(
      tester,
      today: DateTime(2026, 10, 15),
      missing: [
        {'market': 'KRX', 'year': 2027},
      ],
    );
    expect(find.text('2026년 10월'), findsOneWidget);
    expect(find.textContaining('휴장 정보가 아직 없습니다'), findsNothing);
  });

  testWidgets('영어 문구', (tester) async {
    await _pump(
      tester,
      today: DateTime(2026, 11, 21),
      missing: const [],
      locale: const Locale('en'),
    );
    expect(find.text('Market holidays'), findsOneWidget);
    expect(find.text('November 2026'), findsOneWidget);
    expect(find.text('11/28 (Sat)'), findsNWidgets(2));
    expect(_rich('Early close 03:00 · Day after Thanksgiving'), findsOneWidget);
    expect(
      _rich('Closed (trading halts 04:30) · Thanksgiving Day'),
      findsOneWidget,
    );
  });
}
