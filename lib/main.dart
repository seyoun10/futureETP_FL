import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/storage/secure_storage.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 키 유무가 첫 화면(A 또는 B-b)을 정하므로 첫 프레임 전에 한 번 읽는다(D-077).
  final storedKey = await readStoredAccessKey(appSecureStorage);
  runApp(
    ProviderScope(
      // 재시도 규칙(D-042): NETWORK·TIMEOUT·INTERNAL만 최대 2회
      retry: appRetry,
      // UNAUTHORIZED를 한곳에 모아 B-b로 보낸다(D-079)
      observers: const [AuthErrorObserver()],
      overrides: [storedAccessKeyProvider.overrideWithValue(storedKey)],
      child: const App(),
    ),
  );
}
