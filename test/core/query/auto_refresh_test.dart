import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:material_ui/material_ui.dart';

const _minute = Duration(minutes: 1);

/// 조회 결과: `nextUpdateAt`(지금부터 떨어진 시간, null이면 없음) 또는 에러.
sealed class _Result;

class _Ok extends _Result {
  new(this.nextIn);
  final Duration? nextIn;
}

class _Fail extends _Result;

/// 조회마다 [results]를 하나씩 꺼내고(다 쓰면 마지막 것을 되풀이) 횟수를 센다.
class _Query extends AutoRefreshNotifier<DateTime?> {
  new(this.results, {this.chart = false});

  final List<_Result> results;
  final bool chart;
  int fetches = 0;

  @override
  bool get staleUntilNextUpdate => chart;

  @override
  Future<DateTime?> fetch() async {
    final result =
        results[fetches < results.length ? fetches : results.length - 1];
    fetches++;
    return switch (result) {
      _Ok(:final nextIn) => nextIn == null ? null : clock.now().add(nextIn),
      _Fail() => throw const AppError(AppErrorCode.network),
    };
  }

  @override
  DateTime? nextUpdateAtOf(DateTime? data) => data;
}

/// 재시도 없이 `_Query`를 구독한다.
Future<(ProviderSubscription<AsyncValue<DateTime?>>, _Query)> _start(
  WidgetTester tester,
  List<_Result> results, {
  bool chart = false,
}) async {
  final query = _Query(results, chart: chart);
  final provider = AsyncNotifierProvider<_Query, DateTime?>(() => query);
  final container = ProviderContainer(retry: (_, _) => null);
  addTearDown(container.dispose);
  final sub = container.listen(provider, (_, _) {});
  await tester.pump();
  return (sub, query);
}

Future<void> _setLifecycle(WidgetTester tester, AppLifecycleState state) async {
  tester.binding.handleAppLifecycleStateChanged(state);
  // Riverpod는 다시 조회를 0초 타이머로 미룬다
  await tester.pump(Duration.zero);
}

void main() {
  test('nextUpdateAt + 1분, 마지막 조회 1분 뒤 중 늦은 쪽', () {
    final now = DateTime.utc(2026, 10, 22, 14);
    expect(
      autoRefreshAt(nextUpdateAt: now.add(_minute * 5), lastFetchedAt: now),
      now.add(_minute * 6),
    );
    expect(
      autoRefreshAt(
        nextUpdateAt: now.subtract(_minute * 60),
        lastFetchedAt: now,
      ),
      now.add(_minute),
    );
  });

  testWidgets('nextUpdateAt + 1분에 다시 조회한다', (tester) async {
    final (_, query) = await _start(tester, [_Ok(_minute * 5), _Ok(null)]);
    expect(query.fetches, 1);
    await tester.pump(_minute * 6 - const Duration(milliseconds: 1));
    expect(query.fetches, 1);
    await tester.pump(const Duration(milliseconds: 1));
    expect(query.fetches, 2);
  });

  testWidgets('nextUpdateAt이 null이면 자동 새로고침하지 않는다', (tester) async {
    final (_, query) = await _start(tester, [_Ok(null)]);
    await tester.pump(const Duration(hours: 1));
    expect(query.fetches, 1);
  });

  testWidgets('새로고침이 실패하면 이전 값으로 1분 뒤 다시 시도한다', (tester) async {
    final (_, query) = await _start(tester, [
      _Ok(_minute * -60),
      _Fail(),
      _Fail(),
    ]);
    await tester.pump(_minute);
    expect(query.fetches, 2);
    await tester.pump(_minute);
    expect(query.fetches, 3);
  });

  testWidgets('처음 조회가 실패하면 자동 새로고침하지 않는다', (tester) async {
    final (_, query) = await _start(tester, [_Fail()]);
    await tester.pump(const Duration(hours: 1));
    expect(query.fetches, 1);
  });

  testWidgets('앱이 뒤에 있으면 타이머가 돌아도 부르지 않고, 돌아오면 다시 조회한다', (tester) async {
    final (_, query) = await _start(tester, [_Ok(_minute * 5)]);
    await _setLifecycle(tester, AppLifecycleState.inactive);
    await _setLifecycle(tester, AppLifecycleState.hidden);
    await _setLifecycle(tester, AppLifecycleState.paused);
    await tester.pump(_minute * 10);
    expect(query.fetches, 1);
    await _setLifecycle(tester, AppLifecycleState.hidden);
    await _setLifecycle(tester, AppLifecycleState.inactive);
    await _setLifecycle(tester, AppLifecycleState.resumed);
    expect(query.fetches, 2);
  });

  testWidgets('차트는 nextUpdateAt 전 복귀면 다시 조회하지 않는다', (tester) async {
    final (_, query) = await _start(tester, [_Ok(_minute * 5)], chart: true);
    await _setLifecycle(tester, AppLifecycleState.inactive);
    await _setLifecycle(tester, AppLifecycleState.resumed);
    expect(query.fetches, 1);

    await _setLifecycle(tester, AppLifecycleState.inactive);
    await tester.pump(_minute * 5);
    await _setLifecycle(tester, AppLifecycleState.resumed);
    expect(query.fetches, 2);
  });

  testWidgets('화면이 안 보이면(구독 멈춤) 보이게 될 때 다시 조회한다', (tester) async {
    final (sub, query) = await _start(tester, [_Ok(_minute * 5)]);
    sub.pause();
    await tester.pump(_minute * 10);
    expect(query.fetches, 1);
    sub.resume();
    await tester.pump(Duration.zero);
    expect(query.fetches, 2);
  });
}
