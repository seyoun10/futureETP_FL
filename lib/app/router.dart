import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/features/access_key/access_key_screen.dart';
import 'package:futureetp/features/dev_health/health_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// 경로(RN Expo Router와 같은 경로, D-074).
abstract final class AppRoutes {
  static const home = '/';
  static const accessKey = '/settings/access-key';
}

/// 앱 라우터.
///
/// - 키가 없으면 어느 경로든 B-b로 바꾼다. 이때 B-b가 스택의 처음이라 [←]가 없다(D-077).
/// - 저장된 키가 거절되면(`rejected`) 지금 화면 위에 B-b를 올린다. 이미 B-b면 그대로다(D-079).
final routerProvider = Provider<GoRouter>((ref) {
  final hasKey = ValueNotifier(ref.read(accessKeyProvider).hasKey);
  final router = GoRouter(
    refreshListenable: hasKey,
    redirect: (context, state) =>
        !hasKey.value && state.matchedLocation != AppRoutes.accessKey
        ? AppRoutes.accessKey
        : null,
    routes: [
      // A 원자재 목록 자리. 4단계 A 화면이 생기면 바꾼다.
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HealthScreen(),
      ),
      GoRoute(
        path: AppRoutes.accessKey,
        builder: (context, state) => const AccessKeyScreen(),
      ),
    ],
  );
  ref
    ..listen(
      accessKeyProvider.select((s) => s.hasKey),
      (_, value) => hasKey.value = value,
    )
    ..listen(accessKeyProvider.select((s) => s.rejected), (_, rejected) {
      if (rejected && router.state.matchedLocation != AppRoutes.accessKey) {
        unawaited(router.push(AppRoutes.accessKey));
      }
    })
    ..onDispose(() {
      router.dispose();
      hasKey.dispose();
    });
  return router;
});
