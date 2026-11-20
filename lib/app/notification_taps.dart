import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/app/router.dart';
import 'package:futureetp/core/push/push_registration.dart';
import 'package:futureetp/core/push/push_service.dart';
import 'package:futureetp/features/commodity/commodity_tab.dart';

/// 알림을 누르면 해당 화면으로 간다(screens.md X, RN `NotificationTapHandler`).
///
/// 앱이 꺼져 있었으면 실행한 알림을 한 번 읽는다(읽으면 지워져 다시 만들어져도 또 가지 않는다).
/// C는 A 아래 경로라 C로 바로 들어와도 [←]가 A로 간다. 키가 없으면 라우터가 B-b로 바꾼다.
final notificationTapsProvider = Provider<void>((ref) {
  final push = ref.watch(pushServiceProvider);
  final router = ref.watch(routerProvider);

  void open(PushData data) => router.go(switch (notificationCommodity(data)) {
    final code? => CommodityTab.disparity.location(code.wire),
    null => AppRoutes.home,
  });

  unawaited(
    push.takeInitialTap().then((data) {
      if (data != null && ref.mounted) open(data);
    }),
  );
  final subscription = push.onTap.listen(open);
  ref.onDispose(subscription.cancel);
});
