import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/calendar.dart';
import 'package:futureetp/features/calendar/calendar_provider.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/fake_http.dart';

const CalendarRange _range = (from: '2026-11-01', to: '2027-01-31');

Map<String, Object?> _calendar({bool missing = false}) => {
  'from': _range.from,
  'to': _range.to,
  'exceptions': <Object?>[],
  'missing': [
    if (missing) {'market': 'KRX', 'year': 2027},
  ],
};

/// 재시도 없이 달력 조회를 띄운다. 응답은 늘 [missing] 여부만 다른 같은 달력.
Future<(ProviderContainer, FakeHttpAdapter)> _start(
  WidgetTester tester, {
  bool missing = false,
}) async {
  final adapter = FakeHttpAdapter.always(
    FakeResponse.ok(_calendar(missing: missing)),
  );
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      apiClientProvider.overrideWith(
        (ref) => ApiClient(
          Dio(BaseOptions(baseUrl: 'http://test/v1'))
            ..httpClientAdapter = adapter,
          accessToken: () async => 'key',
          deviceId: () async => 'device',
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return (container, adapter);
}

/// 화면에 들어가 조회가 끝날 때까지 기다린다. 닫으면 화면을 떠난 것.
Future<ProviderSubscription<AsyncValue<MarketCalendar>>> _enter(
  WidgetTester tester,
  ProviderContainer container,
) async {
  final sub = container.listen(calendarProvider(_range), (_, _) {});
  await _settle(tester);
  return sub;
}

/// 가짜 응답이 끝나도록 fake 시간에서 마이크로태스크·0초 타이머를 돌린다.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(Duration.zero);
  }
}

Future<void> _resumeApp(WidgetTester tester) async {
  const [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ].forEach(tester.binding.handleAppLifecycleStateChanged);
  await _settle(tester);
}

void main() {
  test('missing이 있으면 5분, 없으면 12시간 새 값으로 본다', () {
    final full = MarketCalendar.fromJson(_calendar());
    final partial = MarketCalendar.fromJson(_calendar(missing: true));
    expect(calendarStaleTimeOf(full), calendarStaleTime);
    expect(calendarStaleTimeOf(partial), calendarMissingStaleTime);
    expect(calendarMissingStaleTime, lessThan(calendarStaleTime));
  });

  testWidgets('from·to를 쿼리로 보낸다', (tester) async {
    final (container, adapter) = await _start(tester);
    await _enter(tester, container);
    final req = adapter.requests.single;
    expect(req.uri.path, '/v1/calendar');
    expect(req.uri.queryParameters, {'from': _range.from, 'to': _range.to});
  });

  testWidgets('모두 입력된 달력은 다시 들어와도·앱이 돌아와도 12시간 안엔 다시 받지 않는다', (tester) async {
    final (container, adapter) = await _start(tester);
    final sub = await _enter(tester, container);
    sub.close();
    await tester.pump(const Duration(minutes: 3));
    await _enter(tester, container);
    await tester.pump(const Duration(hours: 1));
    await _resumeApp(tester);
    expect(adapter.requests, hasLength(1));

    await tester.pump(calendarStaleTime);
    await _resumeApp(tester);
    expect(adapter.requests, hasLength(2));
  });

  testWidgets('입력되지 않은 연도가 있으면 5분 뒤 앱이 돌아올 때 다시 받는다', (tester) async {
    final (container, adapter) = await _start(tester, missing: true);
    await _enter(tester, container);
    await tester.pump(const Duration(minutes: 4));
    await _resumeApp(tester);
    expect(adapter.requests, hasLength(1));

    await tester.pump(const Duration(minutes: 2));
    await _resumeApp(tester);
    expect(adapter.requests, hasLength(2));
  });

  testWidgets('입력되지 않은 연도가 있으면 5분 뒤 다시 들어올 때 다시 받는다', (tester) async {
    final (container, adapter) = await _start(tester, missing: true);
    final sub = await _enter(tester, container);
    sub.close();
    await tester.pump(const Duration(minutes: 4));
    final again = await _enter(tester, container);
    expect(adapter.requests, hasLength(1));
    again.close();
    await tester.pump(const Duration(minutes: 2));
    await _enter(tester, container);
    expect(adapter.requests, hasLength(2));
  });
}
