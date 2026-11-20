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

/// 서버에 저장된 이 기기의 설정(`GET·PATCH /v1/settings`, D-120). 상태는 서버가 확인한 값만 둔다.
/// 화면은 아직 끝나지 않은 변경을 얹은 [settingsViewProvider]를 읽는다(D-082, RN `useSettings`).
/// 접근 키가 바뀌면 client가 바뀌어 다시 받는다. 앱이 앞으로 돌아오면 다시 받는다(D-030, D-084).
class DeviceSettingsNotifier extends AsyncNotifier<DeviceSettings> {
  /// 보낸 순서대로 하나씩 PATCH한다(RN mutation scope `settings`). 실패해도 다음은 간다.
  Future<void> _queue = Future.value();

  @override
  Future<DeviceSettings> build() {
    ref.listen(appLifecycleProvider, (_, next) {
      if (next == AppLifecycleState.resumed) ref.invalidateSelf();
    });
    return ref.watch(apiClientProvider).getSettings();
  }

  /// 바꿀 필드만 보낸다. 앞선 PATCH가 끝난 뒤 보내고, 끝날 때까지 [settingsViewProvider]에 얹어 보인다.
  /// 변경 요청이라 자동 재시도하지 않고 실패는 그대로 던진다(D-072).
  /// 성공하면 서버가 돌려준 설정(그 시점의 전체 값)으로 바꾼다.
  Future<DeviceSettings> patch(SettingsPatch patch) {
    final pending = ref.read(pendingSettingsPatchesProvider.notifier)
      ..add(patch);
    final client = ref.read(apiClientProvider);
    final result = _queue.then((_) => client.patchSettings(patch)).then((
      settings,
    ) {
      if (ref.mounted) state = AsyncData(settings);
      return settings;
    });
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result.whenComplete(() => pending.remove(patch));
  }

  /// 화면의 저장. 실패하면 거절을 알리고(D-079) 그 에러를 돌려준다. 성공하면 null.
  Future<Object?> save(SettingsPatch patch) async {
    try {
      await this.patch(patch);
      return null;
    } on Object catch (error) {
      debugPrint('[settings] PATCH failed: $error');
      // Provider 실패가 아니라 observer가 못 보므로 거절은 직접 알린다(D-079)
      if (ref.mounted) ref.read(accessKeyProvider.notifier).reportError(error);
      return error;
    }
  }
}

final deviceSettingsProvider =
    AsyncNotifierProvider<DeviceSettingsNotifier, DeviceSettings>(
      DeviceSettingsNotifier.new,
    );

/// 보냈지만 아직 끝나지 않은 PATCH(보낸 순서).
class PendingSettingsPatches extends Notifier<List<SettingsPatch>> {
  @override
  List<SettingsPatch> build() => const [];

  void add(SettingsPatch patch) => state = [...state, patch];

  void remove(SettingsPatch patch) => state = [
    for (final p in state)
      if (!identical(p, patch)) p,
  ];
}

final pendingSettingsPatchesProvider =
    NotifierProvider<PendingSettingsPatches, List<SettingsPatch>>(
      PendingSettingsPatches.new,
    );

/// 화면에 보이는 설정: 서버 값 위에 끝나지 않은 변경을 보낸 순서대로 얹는다(낙관적 갱신, D-082).
/// 서버 값에는 확인한 값만 두므로 일부가 실패해도 되돌릴 값을 따로 기억하지 않는다.
final settingsViewProvider = Provider<AsyncValue<DeviceSettings>>((ref) {
  final pending = ref.watch(pendingSettingsPatchesProvider);
  return ref
      .watch(deviceSettingsProvider)
      .whenData((s) => pending.fold(s, (acc, patch) => patch.applyTo(acc)));
});

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

  Future<void> send(SettingsPatch patch) =>
      ref.read(deviceSettingsProvider.notifier).save(patch);

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
