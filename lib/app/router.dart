import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/features/access_key/access_key_screen.dart';
import 'package:futureetp/features/chart_spike/chart_spike_screen.dart';
import 'package:futureetp/features/commodity/commodity_shell.dart';
import 'package:futureetp/features/commodity/commodity_tab.dart';
import 'package:futureetp/features/commodity/tab_placeholder.dart';
import 'package:futureetp/features/commodity_list/commodity_list_screen.dart';
import 'package:futureetp/features/dev_health/health_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// 경로(RN Expo Router와 같은 경로, D-074).
abstract final class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const accessKey = '/settings/access-key';

  /// 4단계 차트 스파이크(dev). 스파이크가 끝나면 지운다.
  static const chartSpike = '/dev/chart-spike';
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
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => CommodityListScreen(
          onOpenSettings: () => unawaited(context.push(AppRoutes.settings)),
          onOpenCommodity: (code) =>
              context.go(CommodityTab.disparity.location(code)),
        ),
        // C는 A 아래 경로라 스택이 늘 A → C다(Android 뒤로·[←]가 A로 간다)
        routes: [_commodityRoute],
      ),
      // B 설정 자리. B 화면이 생기면 바꾼다(지금은 서버 연결 확인·차트 스파이크 진입)
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const HealthScreen(),
      ),
      GoRoute(
        path: AppRoutes.accessKey,
        builder: (context, state) => const AccessKeyScreen(),
      ),
      GoRoute(
        path: AppRoutes.chartSpike,
        builder: (context, state) => const ChartSpikeScreen(),
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

/// C 원자재 화면: 하단 탭 4개를 탭마다 상태를 남기는 shell로 둔다(FL-005, D-047, D-111).
/// 탭은 위치(`/commodity/GC/contracts`)로 바꾼다.
final _commodityRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, shell) => CommodityShell(
    codeText: state.pathParameters['code'] ?? '',
    shell: shell,
    onBack: () => context.go(AppRoutes.home),
    onOpenSettings: () => unawaited(context.push(AppRoutes.settings)),
  ),
  branches: [
    for (final tab in CommodityTab.values)
      StatefulShellBranch(
        // go_router는 경로 값이 있는 branch에 기본 위치를 요구한다. 탭은 위치로 바꾸고
        // goBranch를 쓰지 않아 실제로는 쓰이지 않는다
        initialLocation: tab.location(CommodityCode.gc.wire),
        routes: [
          GoRoute(
            path: tab == CommodityTab.disparity
                ? 'commodity/:code'
                : 'commodity/:code/${tab.segment}',
            builder: (context, state) => const TabPlaceholder(),
          ),
        ],
      ),
  ],
);
