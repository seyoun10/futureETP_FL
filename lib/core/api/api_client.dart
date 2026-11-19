import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/device_id.dart';
import 'package:futureetp/core/api/health.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/config/app_config.dart';

/// 접근 키를 읽는 곳(D-072). 없으면 null.
typedef AccessTokenReader = Future<String?> Function();

/// 봉투의 `data`를 모델로 바꾼다. 스키마와 다르면 아무 예외나 던진다.
typedef DataDecoder<T> = T Function(Object? data);

enum ApiMethod {
  get('GET'),
  patch('PATCH'),
  put('PUT');

  new(this.wire);

  final String wire;
}

/// 서버 API 호출의 유일한 경로(D-042, D-072).
///
/// 인증 헤더, 전체 15초 타임아웃, 봉투·`data` 디코딩을 맡고 실패는 모두 [AppError]로 던진다.
/// 호출자 취소([CancelToken])만 원래 [DioException] 그대로 던진다. 재시도는 [appRetry].
class ApiClient {
  new(
    this._dio, {
    required this._accessToken,
    required this._deviceId,
    this._timeout = defaultTimeout,
  });

  factory forConfig(
    AppConfig config, {
    required AccessTokenReader accessToken,
    required Future<String> Function() deviceId,
  }) => ApiClient(
    Dio(BaseOptions(baseUrl: '${config.apiUrl}/v1')),
    accessToken: accessToken,
    deviceId: deviceId,
  );

  static const defaultTimeout = Duration(seconds: 15);

  final Dio _dio;
  final AccessTokenReader _accessToken;
  final Future<String> Function() _deviceId;
  final Duration _timeout;

  /// `GET /v1/health`(인증 없음).
  Future<Health> getHealth({CancelToken? cancelToken}) => request(
    '/health',
    Health.fromJson,
    auth: false,
    cancelToken: cancelToken,
  );

  /// `GET /v1/settings`. [token]을 주면 저장 전 키를 확인한다(D-044, D-081).
  Future<DeviceSettings> getSettings({
    String? token,
    CancelToken? cancelToken,
  }) => request(
    '/settings',
    (data) => DeviceSettings.fromJson(data! as Map<String, dynamic>),
    token: token,
    cancelToken: cancelToken,
  );

  /// [path]는 `/v1` 뒤 경로. [auth]가 false면 인증 헤더 없이 보낸다(`/v1/health`).
  /// [token]이 있으면 저장된 키 대신 보낸다(B-b에서 저장 전 키 확인, D-044).
  Future<T> request<T>(
    String path,
    DataDecoder<T> decode, {
    ApiMethod method = ApiMethod.get,
    Map<String, Object?>? query,
    Object? body,
    bool auth = true,
    String? token,
    CancelToken? cancelToken,
  }) async {
    final headers = <String, Object>{'Accept': 'application/json'};
    if (auth) {
      final key = token ?? await _accessToken();
      // 키가 없으면 보내도 401이라 요청하지 않는다(D-072).
      if (key == null) {
        throw const AppError(
          AppErrorCode.unauthorized,
          message: 'No access token',
        );
      }
      headers['Authorization'] = 'Bearer $key';
      // 서버가 설정·알림을 기기별로 나누는 키(D-120)
      headers[deviceIdHeader] = await _deviceId();
    }
    if (body != null) {
      headers[Headers.contentTypeHeader] = Headers.jsonContentType;
    }

    // Dio 타임아웃은 연결·바이트 사이 간격이라 전체 시간은 직접 잰다(D-072).
    final internal = CancelToken();
    var timedOut = false;
    final timer = Timer(_timeout, () {
      timedOut = true;
      internal.cancel('timeout');
    });
    unawaited(cancelToken?.whenCancel.then((_) => internal.cancel()));

    final Response<String> res;
    try {
      res = await _dio.request<String>(
        path,
        queryParameters: {
          for (final MapEntry(:key, :value) in (query ?? {}).entries)
            if (value != null) key: '$value',
        },
        data: body == null ? null : jsonEncode(body),
        cancelToken: internal,
        options: Options(
          method: method.wire,
          headers: headers,
          responseType: ResponseType.plain,
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (error) {
      if (timedOut) {
        throw AppError(
          AppErrorCode.timeout,
          message: 'Timed out after ${_timeout.inMilliseconds}ms',
          cause: error,
        );
      }
      if (cancelToken?.isCancelled ?? false) rethrow;
      throw AppError(
        AppErrorCode.network,
        message: 'Network request failed: ${error.type.name}',
        cause: error,
      );
    } finally {
      timer.cancel();
    }

    final data = _decodeEnvelope<T>(
      res.data ?? '',
      res.statusCode ?? 0,
      decode,
      path,
    );
    return data;
  }

  static T _decodeEnvelope<T>(
    String text,
    int status,
    DataDecoder<T> decode,
    String path,
  ) {
    switch (_tryJsonDecode(text)) {
      case {'success': true, 'data': final Object? data}:
        try {
          return decode(data);
        } on Object catch (error) {
          throw AppError(
            AppErrorCode.schemaMismatch,
            message: 'Response data does not match schema: $path',
            status: status,
            cause: error,
          );
        }
      case {
            'success': false,
            'error': {
              'code': final String code,
              'message': final String message,
            },
          }
          when AppErrorCode.parseServer(code) != null:
        throw AppError(
          AppErrorCode.parseServer(code)!,
          message: message,
          status: status,
        );
      default:
        // 프록시 오류(502 HTML 등)처럼 봉투가 아닌 응답은 HTTP 상태로 구분한다.
        // 모르는 에러 코드도 봉투 불일치다(D-072).
        throw AppError(
          status >= 500 ? AppErrorCode.internal : AppErrorCode.schemaMismatch,
          message: 'Unexpected response body (HTTP $status)',
          status: status,
        );
    }
  }

  static Object? _tryJsonDecode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
    }
  }
}

/// 접근 키는 [accessKeyProvider]의 메모리 값을 요청 때마다 읽는다(키를 바꿔도 client는 그대로).
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final deviceIds = ref.watch(deviceIdStoreProvider);
  return ApiClient.forConfig(
    config,
    accessToken: () async => ref.read(accessKeyProvider).key,
    deviceId: deviceIds.get,
  );
});
