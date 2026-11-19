/// 실패 코드(D-042). 서버 코드 + 앱 코드(`NETWORK`·`TIMEOUT`·`SCHEMA_MISMATCH`).
/// 화면은 [AppError.code]만 보고 문구를 고른다.
enum AppErrorCode {
  unauthorized('UNAUTHORIZED', fromServer: true),
  rateLimited('RATE_LIMITED', fromServer: true),
  validationFailed('VALIDATION_FAILED', fromServer: true),
  notFound('NOT_FOUND', fromServer: true),
  internal('INTERNAL', fromServer: true, retryable: true),
  network('NETWORK', retryable: true),
  timeout('TIMEOUT', retryable: true),
  schemaMismatch('SCHEMA_MISMATCH');

  new(this.wire, {this.fromServer = false, this.retryable = false});

  /// 서버·문서에 쓰는 이름(`UNAUTHORIZED` 등).
  final String wire;

  /// 서버 봉투의 `error.code`로 오는 코드인지(`packages/shared` `API_ERROR_CODES`).
  final bool fromServer;

  /// 자동 재시도 대상인지(D-072).
  final bool retryable;

  /// 서버 에러 코드 문자열을 읽는다. 모르는 코드(서버가 더 새 버전)면 null.
  static AppErrorCode? parseServer(String code) {
    for (final value in values) {
      if (value.fromServer && value.wire == code) return value;
    }
    return null;
  }
}

/// API 호출의 모든 실패(D-042). 호출자 취소만 원래 예외 그대로 던진다.
class AppError implements Exception {
  const new(this.code, {this.message, this.status, this.cause});

  final AppErrorCode code;

  /// 개발·로그용 영문. 사용자에게 보이지 않는다.
  final String? message;

  /// HTTP 상태(응답을 받았을 때만).
  final int? status;

  final Object? cause;

  @override
  String toString() =>
      'AppError(${code.wire}'
      '${status == null ? '' : ', HTTP $status'}'
      '${message == null ? '' : ', $message'})';
}

/// 재시도 대상인지. [AppError]가 아닌 예외(코드 버그)는 재시도하지 않는다(D-072).
bool isRetryable(Object error) => error is AppError && error.code.retryable;

/// 자동 재시도 최대 횟수(D-042).
const maxRetries = 2;

/// Riverpod `ProviderScope.retry`. `NETWORK`·`TIMEOUT`·`INTERNAL`만 최대 2회,
/// 간격은 RN(TanStack Query 기본값)과 같은 1초·2초.
/// 변경 요청은 Riverpod Provider가 아닌 곳에서 부르므로 자동 재시도하지 않는다.
Duration? appRetry(int retryCount, Object error) {
  if (retryCount >= maxRetries || !isRetryable(error)) return null;
  return Duration(seconds: 1 << retryCount);
}
