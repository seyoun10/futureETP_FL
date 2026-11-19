import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:material_ui/material_ui.dart';

/// 서버에 저장된 이 기기의 설정(`GET·PATCH /v1/settings`, D-120).
/// 접근 키가 바뀌면 client가 바뀌어 다시 받는다. 앱이 앞으로 돌아오면 다시 받는다(D-030, D-084).
class DeviceSettingsNotifier extends AsyncNotifier<DeviceSettings> {
  @override
  Future<DeviceSettings> build() {
    ref.listen(appLifecycleProvider, (_, next) {
      if (next == AppLifecycleState.resumed) ref.invalidateSelf();
    });
    return ref.watch(apiClientProvider).getSettings();
  }

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

/// IANA 시간대 이름 모양(`Asia/Seoul`·`America/Argentina/Buenos_Aires`·`UTC`).
/// 서버가 거절하면 같이 보낸 언어도 못 바꾸므로 모양이 다르면 보내지 않는다.
final _timeZonePattern = RegExp(
  r'^[A-Za-z][A-Za-z0-9_+-]*(/[A-Za-z0-9_+-]+)*$',
);

/// 기기 시간대(IANA). 읽지 못하면 null.
final deviceTimeZoneProvider = Provider<Future<String?> Function()>(
  (ref) => () async {
    try {
      final id = (await FlutterTimezone.getLocalTimezone()).identifier;
      return _timeZonePattern.hasMatch(id) ? id : null;
    } on Object catch (error) {
      debugPrint('[device-settings-sync] time zone unavailable: $error');
      return null;
    }
  },
);

/// 기기 시간대·앱 언어가 서버 값과 다르면 PATCH한다
/// (D-048, D-084, D-137, RN `DeviceSettingsSync`).
///
/// 서버 언어는 푸시 문구용 사본이고 앱 언어가 원본이다(D-082). 새 기기 행의 기본값(ko)이
/// 앱 언어와 다를 때 맞춘다. 설정을 다시 받을 때마다(앱 복귀 포함)와 앱 언어가 바뀔 때 비교하고,
/// 같은 값은 프로세스당 한 번만 보낸다(실패해도 되풀이하지 않음). 둘 다 다르면 한 번에 보낸다.
/// 앱 루트가 키가 있을 때만 watch한다.
final deviceSettingsSyncProvider = Provider<void>((ref) {
  AppLanguage? sentLocale;
  String? sentTimeZone;

  Future<void> send(SettingsPatch patch) async {
    try {
      await ref.read(deviceSettingsProvider.notifier).patch(patch);
    } on Object catch (error) {
      debugPrint('[device-settings-sync] PATCH failed: $error');
      // Provider 실패가 아니라 observer가 못 보므로 거절은 직접 알린다(D-079)
      if (ref.mounted) ref.read(accessKeyProvider.notifier).reportError(error);
    }
  }

  Future<void> check() async {
    final timeZone = await ref.read(deviceTimeZoneProvider)();
    if (!ref.mounted) return;
    // 다시 받는 중(AsyncLoading)이나 실패면 다음 결과를 기다린다.
    // 기다린 뒤 비교·기록을 한 번에 해 겹친 check가 같은 값을 두 번 보내지 않는다.
    if (ref.read(deviceSettingsProvider) case AsyncData(
      value: DeviceSettings(:final locale, timezone: final serverTimeZone),
    )) {
      final language = ref.read(displaySettingsProvider).language;
      final sendLocale = language != locale && language != sentLocale;
      final sendTimeZone =
          timeZone != null &&
          timeZone != serverTimeZone &&
          timeZone != sentTimeZone;
      if (!sendLocale && !sendTimeZone) return;
      if (sendLocale) sentLocale = language;
      if (sendTimeZone) sentTimeZone = timeZone;
      unawaited(
        send(
          SettingsPatch(
            locale: sendLocale ? language : null,
            timezone: sendTimeZone ? timeZone : null,
          ),
        ),
      );
    }
  }

  ref
    ..listen(
      deviceSettingsProvider,
      (_, _) => unawaited(check()),
      fireImmediately: true,
    )
    ..listen(
      displaySettingsProvider.select((s) => s.language),
      (_, _) => unawaited(check()),
    );
});
