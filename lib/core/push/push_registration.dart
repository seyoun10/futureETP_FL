import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/device.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/config/app_version.dart';
import 'package:futureetp/core/push/push_service.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 푸시 토큰을 서버에 등록한다(D-037, D-048, D-120, RN `PushRegistration`).
///
/// 접근 키가 있을 때 앱 루트가 watch한다. 키가 바뀌면(client가 바뀌면) 다시 만들어져 새 키로
/// 등록한다. 채널 이름은 앱 언어를 따르고, 등록은 키마다 한 번만 한다. 실패하면(거절된 키의
/// 401, 토큰 조회 오류 등) 앱 언어나 접근 키가 바뀔 때, 아니면 다음 실행 때 다시 시도한다.
/// 빈 토큰이면 토큰 없이 등록해 서버가 이 기기로 보내지 않게 하고, 토큰 조회가 실패하면
/// 일시 오류일 수 있어 등록하지 않는다.
final pushRegistrationProvider = Provider<void>((ref) {
  final push = ref.watch(pushServiceProvider);
  final platform = push.platform;
  final client = ref.watch(apiClientProvider);
  if (platform == null ||
      !ref.watch(accessKeyProvider.select((s) => s.hasKey))) {
    return;
  }

  var registered = false;
  // 마지막으로 등록한(또는 등록 중인) 토큰. 같은 토큰 이벤트는 다시 등록하지 않는다
  String? lastToken;

  Future<void> register(String? token) async {
    final version = await ref.read(appVersionProvider.future);
    await client.putDevice(
      DeviceRegistration(
        pushToken: token,
        platform: platform,
        // 같은 서버를 쓰는 다른 클라이언트와 구분한다(FL-002)
        appVersion: 'fl-${version.version}',
      ),
    );
  }

  Future<void> setup(AppLanguage language) async {
    try {
      final l10n = lookupAppLocalizations(Locale(language.name));
      await push.setupChannels({
        AndroidChannel.alerts: l10n.pushChannelAlerts,
        AndroidChannel.ops: l10n.pushChannelOps,
      });
      if (registered || !ref.mounted) return;
      registered = true;
      try {
        // Android 13+는 채널이 있어야 권한 창이 뜬다
        await push.requestPermission();
        final token = await push.getToken();
        final value = token == null || token.isEmpty ? null : token;
        await register(value);
        lastToken = value;
      } on Object {
        registered = false;
        rethrow;
      }
    } on Object catch (error) {
      debugPrint('[push] registration failed: $error');
    }
  }

  // FCM이 토큰을 바꾸면 새 토큰을 다시 등록한다. 옛 토큰은 발송 때 UNREGISTERED로 지워진다(D-023).
  // 첫 등록과 겹치면 한 번 더 등록될 수 있다(PUT이라 무해).
  final subscription = push.onTokenRefresh.listen((token) {
    if (token.isEmpty || token == lastToken) return;
    lastToken = token;
    unawaited(
      register(token).catchError((Object error) {
        lastToken = null;
        debugPrint('[push] re-registration failed: $error');
      }),
    );
  });
  ref
    ..onDispose(subscription.cancel)
    ..listen(
      displaySettingsProvider.select((s) => s.language),
      (_, language) => unawaited(setup(language)),
      fireImmediately: true,
    );
});

/// 알림을 눌렀을 때 갈 원자재(screens.md X, RN `notificationHref`).
/// rare 레벨 알림은 그 원자재의 C-a, 운영·ETP 새 후보(D-025)·다수 판정 변경(D-024)·모르는 알림은
/// null(A)이다. 서버 type은 `jobs/rareAlert.ts` 등.
CommodityCode? notificationCommodity(PushData? data) => switch (data) {
  {'type': 'RARE_LEVEL', 'commodity': final String code} =>
    CommodityCode.fromWire(code),
  _ => null,
};
