import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/config/app_config.dart';

const _key = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJ0123-_6';

const _prod = AppConfig(variant: AppVariant.prod, apiUrl: 'http://test');
const _dev = AppConfig(
  variant: AppVariant.dev,
  apiUrl: 'http://test',
  devApiToken: 'dev-token',
);

ProviderContainer _container({String? stored, AppConfig config = _prod}) {
  final container = ProviderContainer(
    overrides: [
      storedAccessKeyProvider.overrideWithValue(stored),
      appConfigProvider.overrideWithValue(config),
    ],
    observers: const [AuthErrorObserver()],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  group('parseAccessKey', () {
    test('붙여넣기는 키만 또는 접두사 붙은 키, 앞뒤 공백 허용', () {
      expect(parseAccessKey(_key), _key);
      expect(parseAccessKey(' $_key\n'), _key);
      expect(parseAccessKey('$accessKeyQrPrefix$_key'), _key);
    });

    test('QR은 접두사가 있어야 한다', () {
      expect(parseAccessKey(_key, requirePrefix: true), isNull);
      expect(
        parseAccessKey('$accessKeyQrPrefix$_key', requirePrefix: true),
        _key,
      );
    });

    test('형식이 아니면 null', () {
      for (final bad in [
        '',
        _key.substring(1),
        '${_key}x',
        '${_key.substring(1)}=',
        'futureetp-key:v2:$_key',
      ]) {
        expect(parseAccessKey(bad), isNull, reason: bad);
      }
    });
  });

  group('AccessKeyNotifier', () {
    test('저장된 키가 우선, 없으면 dev 토큰, prod는 키 없음', () {
      expect(_container(stored: _key).read(accessKeyProvider).key, _key);
      expect(
        _container(stored: _key, config: _dev).read(accessKeyProvider).key,
        _key,
      );
      expect(_container(config: _dev).read(accessKeyProvider).key, 'dev-token');
      expect(_container().read(accessKeyProvider).hasKey, isFalse);
    });

    test('save는 보안 저장소에 쓰고 거절 표시를 지운다', () async {
      final container = _container(stored: 'old');
      container
          .read(accessKeyProvider.notifier)
          .reportError(const AppError(AppErrorCode.unauthorized));
      expect(container.read(accessKeyProvider).rejected, isTrue);

      await container.read(accessKeyProvider.notifier).save(_key);
      final state = container.read(accessKeyProvider);
      expect(state.key, _key);
      expect(state.rejected, isFalse);
      expect(await readStoredAccessKey(const FlutterSecureStorage()), _key);
    });

    test('UNAUTHORIZED만, 키가 있을 때만 거절로 본다', () {
      final notifier = _container(stored: _key).read(accessKeyProvider.notifier)
        ..reportError(const AppError(AppErrorCode.network));
      expect(notifier.state.rejected, isFalse);
      notifier.reportError(const AppError(AppErrorCode.unauthorized));
      expect(notifier.state.rejected, isTrue);
      notifier.clearRejected();
      expect(notifier.state.rejected, isFalse);

      final noKey = _container().read(accessKeyProvider.notifier)
        ..reportError(const AppError(AppErrorCode.unauthorized));
      expect(noKey.state.rejected, isFalse);
    });

    test('Provider가 UNAUTHORIZED로 실패하면 관찰자가 거절로 표시한다', () async {
      final container = _container(stored: _key);
      final failing = FutureProvider<int>(
        (ref) => throw const AppError(AppErrorCode.unauthorized),
        retry: (_, _) => null,
      );
      await expectLater(
        container.read(failing.future),
        throwsA(isA<AppError>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(container.read(accessKeyProvider).rejected, isTrue);
    });
  });
}
