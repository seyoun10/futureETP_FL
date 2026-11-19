import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';

/// 서버에 저장된 이 기기의 설정(`GET·PATCH /v1/settings`, D-120).
/// 접근 키가 바뀌면 client가 바뀌어 다시 받는다.
class DeviceSettingsNotifier extends AsyncNotifier<DeviceSettings> {
  @override
  Future<DeviceSettings> build() => ref.watch(apiClientProvider).getSettings();

  /// 바꿀 필드만 보낸다. 변경 요청이라 자동 재시도하지 않고 실패는 그대로 던진다(D-072).
  /// 성공하면 서버가 돌려준 설정으로 바꾼다.
  Future<DeviceSettings> patch(SettingsPatch patch) async {
    final settings = await ref.read(apiClientProvider).patchSettings(patch);
    if (ref.mounted) state = AsyncData(settings);
    return settings;
  }
}

final deviceSettingsProvider =
    AsyncNotifierProvider<DeviceSettingsNotifier, DeviceSettings>(
      DeviceSettingsNotifier.new,
    );

/// 앱 언어가 서버 `locale`과 다르면 PATCH한다(D-137, RN `DeviceSettingsSync`).
///
/// 서버 언어는 푸시 문구용 사본이고 앱 언어가 원본이다(D-082). 새 기기 행의 기본값(ko)이
/// 앱 언어와 다를 때 맞춘다. 설정을 다시 받을 때마다와 앱 언어가 바뀔 때 비교하고,
/// 같은 값은 프로세스당 한 번만 보낸다(실패해도 되풀이하지 않음).
/// 앱 루트가 키가 있을 때만 watch한다.
final deviceSettingsSyncProvider = Provider<void>((ref) {
  AppLanguage? sentLocale;

  Future<void> send(SettingsPatch patch) async {
    try {
      await ref.read(deviceSettingsProvider.notifier).patch(patch);
    } on Object catch (error) {
      debugPrint('[device-settings-sync] PATCH failed: $error');
      // Provider 실패가 아니라 observer가 못 보므로 거절은 직접 알린다(D-079)
      if (ref.mounted) ref.read(accessKeyProvider.notifier).reportError(error);
    }
  }

  void check() {
    // 다시 받는 중(AsyncLoading)이나 실패면 다음 결과를 기다린다
    if (ref.read(deviceSettingsProvider) case AsyncData(
      value: DeviceSettings(:final locale),
    )) {
      final language = ref.read(displaySettingsProvider).language;
      if (language == locale || language == sentLocale) return;
      sentLocale = language;
      unawaited(send(SettingsPatch(locale: language)));
    }
  }

  ref
    ..listen(deviceSettingsProvider, (_, _) => check(), fireImmediately: true)
    ..listen(
      displaySettingsProvider.select((s) => s.language),
      (_, _) => check(),
    );
});
