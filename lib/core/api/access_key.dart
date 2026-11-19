import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/config/app_config.dart';
import 'package:futureetp/core/storage/secure_storage.dart';

/// QR 내용 접두사(D-044).
const accessKeyQrPrefix = 'futureetp-key:v1:';

/// 키 형식: 32바이트 난수 base64url(패딩 없음) = 43자.
final _keyPattern = RegExp(r'^[A-Za-z0-9_-]{43}$');

const _storageKey = 'access-key';

/// 입력에서 키를 꺼낸다. QR은 접두사가 있어야 받고([requirePrefix]),
/// 붙여넣기는 키만 넣어도 받는다. 형식이 아니면 null(서버에 묻지 않는다).
String? parseAccessKey(String input, {bool requirePrefix = false}) {
  final text = input.trim();
  final hasPrefix = text.startsWith(accessKeyQrPrefix);
  if (requirePrefix && !hasPrefix) return null;
  final key = hasPrefix ? text.substring(accessKeyQrPrefix.length) : text;
  return _keyPattern.hasMatch(key) ? key : null;
}

/// 앱 시작 때 저장된 키를 한 번 읽는다(`main`에서 `runApp` 전).
/// 읽기 실패(기기 키 저장소 손상 등)는 키 없음으로 보고 B-b에서 다시 넣게 한다.
Future<String?> readStoredAccessKey(FlutterSecureStorage storage) async {
  try {
    return await storage.read(key: _storageKey);
  } on Object catch (error) {
    debugPrint('[access-key] failed to read: $error');
    return null;
  }
}

/// `main`이 읽은 저장된 키로 덮어쓴다. 기본은 키 없음(테스트).
final storedAccessKeyProvider = Provider<String?>((ref) => null);

/// 접근 키 상태(D-077, D-079).
@immutable
class AccessKeyState {
  const new({required this.key, this.rejected = false});

  /// 요청에 보낼 키. 저장된 키가 없으면 dev 변형만 `DEV_API_TOKEN`.
  final String? key;

  /// 저장된 키를 서버가 거절함(`UNAUTHORIZED`). 앱 루트가 보고 B-b로 보낸다.
  /// 키는 새 키를 확인할 때까지 지우지 않는다.
  final bool rejected;

  bool get hasKey => key != null;
}

/// 접근 키를 읽고 바꾸는 유일한 곳(D-072). 키 값은 메모리에 두고 요청마다 저장소를 열지 않는다.
class AccessKeyNotifier extends Notifier<AccessKeyState> {
  @override
  AccessKeyState build() => AccessKeyState(
    key:
        ref.watch(storedAccessKeyProvider) ??
        ref.watch(appConfigProvider).devApiToken,
  );

  /// 서버에서 확인한 키만 넘긴다(D-044). 저장에 성공해야 메모리 값도 바꾼다.
  Future<void> save(String key) async {
    await ref.read(secureStorageProvider).write(key: _storageKey, value: key);
    state = AccessKeyState(key: key);
  }

  /// Provider 실패를 받는다. 저장된 키로 보낸 요청의 `UNAUTHORIZED`만 거절로 본다.
  /// 키가 없어 보내지 않은 요청도 `UNAUTHORIZED`라 키가 있을 때만이다.
  void reportError(Object error) {
    if (error is AppError &&
        error.code == AppErrorCode.unauthorized &&
        state.hasKey &&
        !state.rejected) {
      state = AccessKeyState(key: state.key, rejected: true);
    }
  }

  /// B-b를 떠나면 지운다. 옛 키로 다시 거절되면 다시 B-b로 온다.
  void clearRejected() {
    // B-b dispose에서 미뤄 부르므로 앱(컨테이너)이 먼저 끝났을 수 있다
    if (ref.mounted && state.rejected) state = AccessKeyState(key: state.key);
  }
}

final accessKeyProvider = NotifierProvider<AccessKeyNotifier, AccessKeyState>(
  AccessKeyNotifier.new,
);

/// 모든 Provider 실패를 [AccessKeyNotifier.reportError]로 모은다(D-079).
/// 화면마다 처리하지 않고, 여러 조회가 한꺼번에 거절돼도 표시는 하나다.
/// 실패를 알리는 도중에 다른 Provider를 바꿀 수 없어 다음 microtask로 미룬다.
final class AuthErrorObserver extends ProviderObserver {
  const new();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is! AppError || error.code != AppErrorCode.unauthorized) return;
    final container = context.container;
    scheduleMicrotask(
      () => container.read(accessKeyProvider.notifier).reportError(error),
    );
  }
}
