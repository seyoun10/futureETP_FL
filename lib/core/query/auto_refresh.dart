import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// 배치 완료 예상 시각(`nextUpdateAt`) 뒤 여유(원본 architecture.md freshness).
const autoRefreshMargin = Duration(minutes: 1);

/// 마지막 조회(성공·실패)부터 다음 자동 조회까지의 최소 간격.
/// 예상 시각이 지났거나 조회가 계속 실패할 때 반복을 막는다.
const autoRefreshMinInterval = Duration(minutes: 1);

/// 앱 생명주기. 앞에 있으면 [AppLifecycleState.resumed].
class AppLifecycleNotifier extends Notifier<AppLifecycleState> {
  @override
  AppLifecycleState build() {
    final listener = AppLifecycleListener(
      onStateChange: (value) => state = value,
    );
    ref.onDispose(listener.dispose);
    return WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }
}

final appLifecycleProvider =
    NotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
      AppLifecycleNotifier.new,
    );

/// 다음 자동 조회 시각: `nextUpdateAt` + 1분, 단 마지막 조회 1분 뒤보다 이르지 않다.
DateTime autoRefreshAt({
  required DateTime nextUpdateAt,
  required DateTime lastFetchedAt,
}) {
  final afterBatch = nextUpdateAt.add(autoRefreshMargin);
  final afterLast = lastFetchedAt.add(autoRefreshMinInterval);
  return afterBatch.isAfter(afterLast) ? afterBatch : afterLast;
}

/// freshness가 있는 조회(A·C 화면)의 자동 새로고침과 앱 복귀 재조회(D-048, D-075,
/// RN `useAutoRefresh`·`focusManager`·`chartCacheOptions.staleTime`).
///
/// - 조회가 끝날 때마다(성공·실패) [autoRefreshAt]에 다시 조회한다. 실패하면 이전 값의
///   `nextUpdateAt`을 써서 1분 뒤 다시 시도한다. 값이 없거나 `nextUpdateAt`이 null이면
///   자동 새로고침하지 않는다. 앱이 뒤에 있으면 부르지 않고 복귀 재조회에 맡긴다.
/// - 앱이 앞으로 돌아오면 오래된 값만 다시 조회한다. 기본은 늘 오래된 값이고,
///   [staleUntilNextUpdate]면(C 차트) `nextUpdateAt`까지는 새 값으로 본다.
/// - 화면이 안 보이면(Provider가 멈춤) 다시 조회를 보이게 될 때로 미룬다.
///
/// 재시도(NETWORK·TIMEOUT·INTERNAL 2회)는 [ProviderContainer]의 retry가 맡는다(D-072).
abstract class AutoRefreshNotifier<T> extends AsyncNotifier<T> {
  /// 서버에서 받는다.
  Future<T> fetch();

  /// 받은 값의 다음 갱신 예상 시각.
  DateTime? nextUpdateAtOf(T data);

  /// C 차트처럼 `nextUpdateAt`까지 다시 받지 않을지.
  bool get staleUntilNextUpdate => false;

  @override
  Future<T> build() async {
    // 다시 조회하면 state는 이전 값을 가진 로딩이다
    final previous = state.value;
    try {
      final data = await fetch();
      _schedule(data);
      return data;
    } on Object {
      _schedule(previous);
      rethrow;
    }
  }

  void _schedule(T? data) {
    if (!ref.mounted) return;
    final nextUpdateAt = data == null ? null : nextUpdateAtOf(data);
    final fetchedAt = clock.now();
    if (nextUpdateAt != null) {
      final runAt = autoRefreshAt(
        nextUpdateAt: nextUpdateAt,
        lastFetchedAt: fetchedAt,
      );
      final timer = Timer(runAt.difference(fetchedAt), () {
        if (ref.read(appLifecycleProvider) == AppLifecycleState.resumed) {
          ref.invalidateSelf();
        }
      });
      ref.onDispose(timer.cancel);
    }
    final staleAt = staleUntilNextUpdate ? nextUpdateAt : null;
    ref.listen(appLifecycleProvider, (previous, next) {
      if (next != AppLifecycleState.resumed) return;
      if (staleAt != null && clock.now().isBefore(staleAt)) return;
      ref.invalidateSelf();
    });
  }
}
