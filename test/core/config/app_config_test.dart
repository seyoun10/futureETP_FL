import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/config/app_config.dart';

void main() {
  AppConfig resolve({
    String? flavor = 'dev',
    String url = '',
    String token = '',
    bool isAndroid = true,
  }) => AppConfig.resolve(
    flavor: flavor,
    devApiUrl: url,
    devApiToken: token,
    isAndroid: isAndroid,
  );

  test('prod는 prod 서버를 쓰고 dev 토큰을 넣지 않는다', () {
    final config = resolve(flavor: 'prod', url: 'http://x', token: 't');
    expect(config.variant, AppVariant.prod);
    expect(config.apiUrl, prodApiUrl);
    expect(config.devApiToken, isNull);
  });

  test('flavor가 없으면 prod로 본다', () {
    expect(resolve(flavor: null).variant, AppVariant.prod);
  });

  test('dev는 env 값을 쓴다', () {
    final config = resolve(url: 'http://192.168.0.10:3000', token: 'tok');
    expect(config.variant, AppVariant.dev);
    expect(config.apiUrl, 'http://192.168.0.10:3000');
    expect(config.devApiToken, 'tok');
  });

  test('dev 주소가 비면 에뮬레이터 기본 주소', () {
    expect(resolve().apiUrl, 'http://10.0.2.2:3000');
    expect(resolve(isAndroid: false).apiUrl, 'http://localhost:3000');
    expect(resolve().devApiToken, isNull);
  });
}
