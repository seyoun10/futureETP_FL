import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/push/push_service.dart';
import 'package:material_ui/material_ui.dart';

/// 알림 권한 상태(B-a 권한 배너, RN `usePushPermission`).
///
/// OS 설정에서 바꾸고 돌아올 수 있으므로 앱이 다시 활성화될 때마다 새로 읽는다.
/// 푸시를 못 쓰는 플랫폼이면 null이다.
class PushPermissionNotifier extends AsyncNotifier<PushPermission?> {
  @override
  Future<PushPermission?> build() {
    final push = ref.watch(pushServiceProvider);
    final listener = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.resumed) unawaited(_refresh(push));
      },
    );
    ref.onDispose(listener.dispose);
    return push.getPermission();
  }

  Future<void> _refresh(PushService push) async {
    final permission = await push.getPermission();
    if (ref.mounted) state = AsyncData(permission);
  }

  /// 다시 물을 수 있으면 권한 창을 띄우고, 아니면(영구 거부) 앱 설정 화면을 연다.
  Future<void> request() async {
    final push = ref.read(pushServiceProvider);
    if (state.value?.canAskAgain ?? false) {
      final permission = await push.requestPermission();
      if (ref.mounted) state = AsyncData(permission);
    } else {
      await push.openSettings();
    }
  }
}

/// 알림 권한. B-a가 보는 동안만 살아 있다.
final AsyncNotifierProvider<PushPermissionNotifier, PushPermission?>
pushPermissionProvider =
    AsyncNotifierProvider.autoDispose<PushPermissionNotifier, PushPermission?>(
      PushPermissionNotifier.new,
    );
