import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/push/push_service.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/core/storage/secure_storage.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 세로로 시작한다. 가로는 C-a~C-c [⟲]에서만(D-076)
  await lockPortrait();
  // 키 유무가 첫 화면(A 또는 B-b)을 정하므로 첫 프레임 전에 한 번 읽는다(D-077).
  final storedKey = await readStoredAccessKey(appSecureStorage);
  // 언어·등락 색이 첫 프레임부터 저장된 값이게 한다(D-073)
  final displayStore = await openDisplaySettingsStore();
  final push = await _startPush();
  runApp(
    ProviderScope(
      // 재시도 규칙(D-042): NETWORK·TIMEOUT·INTERNAL만 최대 2회
      retry: appRetry,
      // UNAUTHORIZED를 한곳에 모아 B-b로 보낸다(D-079)
      observers: const [AuthErrorObserver()],
      overrides: [
        storedAccessKeyProvider.overrideWithValue(storedKey),
        displaySettingsStoreProvider.overrideWithValue(displayStore),
        pushServiceProvider.overrideWithValue(push),
      ],
      child: const App(),
    ),
  );
}

/// Android만 FCM을 쓴다. iOS는 Apple 가입 뒤 APNs 기기 토큰으로 붙인다(D-037).
/// Firebase를 켜지 못해도 앱은 푸시 없이 뜬다.
Future<PushService> _startPush() async {
  if (!Platform.isAndroid) return const NoPushService();
  try {
    return await FirebasePushService.start();
  } on Object catch (error) {
    debugPrint('[push] Firebase start failed: $error');
    return const NoPushService();
  }
}
