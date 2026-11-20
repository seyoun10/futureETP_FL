import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:futureetp/core/widgets/footer_line.dart';
import 'package:futureetp/core/widgets/freshness_line.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/features/commodity/chart_busy.dart';
import 'package:futureetp/features/commodity/commodity_tab.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_chart_provider.dart';
import 'package:futureetp/features/commodity/curve/curve_provider.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_provider.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// C 원자재 화면 껍데기(RN `CommodityTabsLayout`·`CommodityTitleBar`).
///
/// - title-bar: [←](A로) `원자재명 (심볼)` 🔔 [⟲](차트 탭만) [⚙]
/// - 하단 탭 4개와 그 아래 지금 탭의 기준 시각 줄. 스와이프로 탭을 바꾸지 않는다(차트 제스처와 겹침).
/// - 가로 모드는 title-bar(낮게)와 차트만 남기고, 차트를 좌우 safe area만큼 안쪽에 둔다(D-103, D-125).
/// - ETP 탭으로 가거나 C를 떠나면 세로로 돌아간다(D-076).
/// - 차트가 이전 3년을 받는 동안 화면 전체 터치를 막는다(D-139).
class CommodityShell extends ConsumerStatefulWidget {
  const new({
    super.key,
    required this.codeText,
    required this.shell,
    required this.onBack,
    required this.onOpenSettings,
  });

  /// 경로의 원자재 코드(모르는 값일 수 있다).
  final String codeText;
  final StatefulNavigationShell shell;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  @override
  ConsumerState<CommodityShell> createState() => _CommodityShellState();
}

class _CommodityShellState extends ConsumerState<CommodityShell> {
  CommodityTab get _tab => CommodityTab.values[widget.shell.currentIndex];

  @override
  void didUpdateWidget(CommodityShell old) {
    super.didUpdateWidget(old);
    if (_tab == CommodityTab.etps &&
        old.shell.currentIndex != widget.shell.currentIndex) {
      unawaited(lockPortrait());
    }
  }

  @override
  void dispose() {
    unawaited(lockPortrait());
    super.dispose();
  }

  /// 지금 탭의 기준 시각 줄. 값이 없으면(첫 조회 중·만들지 않은 탭) 빈 줄로 자리를 지킨다.
  Widget? _footer(CommodityCode? code) {
    if (code == null) return null;
    final freshness = switch (_tab) {
      CommodityTab.disparity => ref.watch(
        disparityChartProvider(code).select((s) => s.value?.chart.freshness),
      ),
      CommodityTab.contracts => ref.watch(
        contractChartProvider(code).select((s) => s.value?.freshness),
      ),
      // 지난 기준일을 봐도 기준 시각 줄은 D 기준 그대로다(기본 기준일 조회의 값)
      CommodityTab.curve => ref.watch(
        curveProvider((code: code, baseDate: null))
            .select((s) => s.value?.freshness),
      ),
      _ => null,
    };
    return freshness == null ? null : FreshnessLine(freshness);
  }

  void _select(CommodityTab tab) {
    if (tab == _tab) return;
    tapHaptic();
    context.go(tab.location(widget.codeText));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = CommodityCode.fromWire(widget.codeText);
    final landscape = isLandscape(context);
    final alertCommodity = ref.watch(
      deviceSettingsProvider.select((s) => s.value?.alertCommodity),
    );
    final busy = ref.watch(chartBusyProvider);
    final padding = MediaQuery.paddingOf(context);
    return AbsorbPointer(
      absorbing: busy,
      child: Scaffold(
        body: Column(
          children: [
            ScreenHeader(
              title: code == null
                  ? widget.codeText
                  : '${l10n.commodityName(code.wire)} (${code.wire})',
              titleAccessory: code != null && alertCommodity == code
                  ? const AlertBell()
                  : null,
              compact: landscape,
              onBack: widget.onBack,
              actions: [
                if (_tab.isChart)
                  HeaderIconButton(
                    key: const Key('commodity-rotate'),
                    icon: landscape
                        ? Icons.stay_current_portrait
                        : Icons.stay_current_landscape,
                    label: l10n.commodityRotate,
                    compact: landscape,
                    onPressed: () =>
                        unawaited(landscape ? lockPortrait() : lockLandscape()),
                  ),
                SettingsHeaderButton(
                  compact: landscape,
                  onPressed: widget.onOpenSettings,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: landscape
                    ? EdgeInsets.only(left: padding.left, right: padding.right)
                    : EdgeInsets.zero,
                child: widget.shell,
              ),
            ),
            if (landscape)
              SizedBox(height: padding.bottom)
            else ...[
              _TabBar(selected: _tab, onSelect: _select),
              FooterLine(child: _footer(code)),
            ],
          ],
        ),
      ),
    );
  }
}

/// 하단 탭 줄. 선택한 탭은 기간 칩과 같이 둥근 `surfaceSelected` 배경에 흰 굵은 글자다.
class _TabBar extends StatelessWidget {
  const new({required this.selected, required this.onSelect});

  final CommodityTab selected;
  final ValueChanged<CommodityTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String label(CommodityTab tab) => switch (tab) {
      CommodityTab.disparity => l10n.commodityTabDisparity,
      CommodityTab.contracts => l10n.commodityTabContracts,
      CommodityTab.curve => l10n.commodityTabCurve,
      CommodityTab.etps => l10n.commodityTabEtps,
    };
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.barSeparator)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            for (final tab in CommodityTab.values)
              Expanded(
                child: _TabItem(
                  key: Key('commodity-tab-${tab.name}'),
                  label: label(tab),
                  selected: tab == selected,
                  onTap: () => onSelect(tab),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: selected ? AppColors.surfaceSelected : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSize.touchTarget,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSize.body,
                color: selected ? AppColors.text : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
