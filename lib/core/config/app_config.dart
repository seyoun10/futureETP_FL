import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 변형(D-043). `--flavor`로 정해진다.
enum AppVariant { dev, prod }

/// prod 서버(D-036). dev 주소·토큰만 `env/dev.json`에서 넣는다(D-044).
const prodApiUrl = 'https://futureetp-api.duckdns.org';

/// 변형별 서버 주소와 dev 전용 토큰.
@immutable
class AppConfig {
  const new({required this.variant, required this.apiUrl, this.devApiToken});

  /// flavor 이름과 dart-define 값으로 설정을 만든다. 값이 비면 에뮬레이터 기본 주소를 쓴다.
  factory resolve({
    required String? flavor,
    required String devApiUrl,
    required String devApiToken,
    required bool isAndroid,
  }) {
    if (flavor != 'dev') {
      return const AppConfig(variant: AppVariant.prod, apiUrl: prodApiUrl);
    }
    final fallback = isAndroid
        ? 'http://10.0.2.2:3000'
        : 'http://localhost:3000';
    return AppConfig(
      variant: AppVariant.dev,
      apiUrl: devApiUrl.isEmpty ? fallback : devApiUrl,
      devApiToken: devApiToken.isEmpty ? null : devApiToken,
    );
  }

  /// 실행 중인 빌드의 설정.
  factory fromEnvironment() => AppConfig.resolve(
    flavor: appFlavor,
    devApiUrl: const String.fromEnvironment('DEV_API_URL'),
    devApiToken: const String.fromEnvironment('DEV_API_TOKEN'),
    isAndroid: defaultTargetPlatform == TargetPlatform.android,
  );

  final AppVariant variant;

  /// 서버 주소(`/v1` 없이).
  final String apiUrl;

  /// dev 변형에서 접근 키 입력을 건너뛸 토큰. prod에서는 항상 null.
  final String? devApiToken;
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
