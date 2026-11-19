import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/health.dart';
import 'package:futureetp/core/config/app_config.dart';

/// 서버 API 호출. 2단계는 health만 둔다. 헤더·AppError·재시도는 3단계(D-042, D-072).
class ApiClient {
  new(this._dio);

  factory forConfig(AppConfig config) => ApiClient(
    Dio(
      BaseOptions(
        baseUrl: '${config.apiUrl}/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
  );

  final Dio _dio;

  Future<Health> getHealth() async {
    final res = await _dio.get<Object?>('/health');
    return Health.fromJson(_unwrap(res.data));
  }

  /// 봉투 `{ success: true, data }`에서 data를 꺼낸다.
  static Object? _unwrap(Object? body) {
    if (body case {'success': true, 'data': final Object? data}) return data;
    throw FormatException('unexpected envelope: $body');
  }
}

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient.forConfig(ref.watch(appConfigProvider)),
);
