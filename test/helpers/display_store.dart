import 'package:futureetp/core/settings/display_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// 메모리 저장소로 표시 설정 store를 연다. [stored]는 저장된 `display-settings` 값.
Future<SharedPreferencesWithCache> openTestDisplayStore({String? stored}) {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData({displaySettingsKey: ?stored});
  return openDisplaySettingsStore();
}
