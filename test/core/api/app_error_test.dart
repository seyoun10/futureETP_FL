import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/app_error.dart';

void main() {
  test('서버 코드는 shared API_ERROR_CODES 다섯 개만 읽는다', () {
    expect(AppErrorCode.values.where((c) => c.fromServer).map((c) => c.wire), [
      'UNAUTHORIZED',
      'RATE_LIMITED',
      'VALIDATION_FAILED',
      'NOT_FOUND',
      'INTERNAL',
    ]);
    expect(AppErrorCode.parseServer('NOT_FOUND'), AppErrorCode.notFound);
    expect(AppErrorCode.parseServer('TIMEOUT'), isNull);
    expect(AppErrorCode.parseServer('NEW_CODE'), isNull);
  });

  test('재시도는 NETWORK·TIMEOUT·INTERNAL만 최대 2회, 1초·2초 간격', () {
    for (final code in AppErrorCode.values) {
      final retryable = {
        AppErrorCode.network,
        AppErrorCode.timeout,
        AppErrorCode.internal,
      }.contains(code);
      final error = AppError(code);
      expect(isRetryable(error), retryable, reason: code.wire);
      expect(
        appRetry(0, error),
        retryable ? const Duration(seconds: 1) : isNull,
      );
      expect(
        appRetry(1, error),
        retryable ? const Duration(seconds: 2) : isNull,
      );
      expect(appRetry(2, error), isNull);
    }
  });

  test('AppError가 아닌 예외는 재시도하지 않는다', () {
    expect(appRetry(0, Exception('bug')), isNull);
    expect(appRetry(0, StateError('bug')), isNull);
  });
}
