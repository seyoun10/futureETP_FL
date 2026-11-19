import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 차트 아래 줄 모양.
enum ChartSkeletonFooter {
  /// 기간 칩(C-a·C-c).
  periods,

  /// 기준일 −/날짜/+(C-b).
  steps,
}

/// 차트 탭 첫 조회 중 화면(RN `ChartSkeleton`). 공용 막대 대신 차트 격자와 아래 줄 자리를 그려
/// 차트가 들어설 자리와 모양을 맞추고, 차트 자리 가운데에 스피너를 겹친다. 캐시가 있으면 보이지 않는다.
class ChartSkeleton extends StatelessWidget {
  const new({super.key, required this.footer});

  final ChartSkeletonFooter footer;

  static const _gridLines = 5;

  @override
  Widget build(BuildContext context) {
    // 가로 모드는 아래 줄을 숨긴다(D-103)
    final landscape = isLandscape(context);
    return Semantics(
      label: AppLocalizations.of(context).loading,
      child: ColoredBox(
        color: AppColors.background,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i = 0; i < _gridLines; i++)
                        const Divider(
                          height: 1,
                          thickness: 0.5,
                          color: ChartColors.grid,
                        ),
                    ],
                  ),
                  const Positioned.fill(child: CenterSpinner()),
                ],
              ),
            ),
            if (!landscape)
              SizedBox(
                height: AppSize.touchTarget,
                child: switch (footer) {
                  ChartSkeletonFooter.periods => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSpacing.sm,
                    children: [for (var i = 0; i < 6; i++) _block(40, 24)],
                  ),
                  ChartSkeletonFooter.steps => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppSpacing.sm,
                      children: [
                        _block(AppSize.touchTarget, AppSize.touchTarget),
                        _block(160, AppSize.touchTarget),
                        _block(AppSize.touchTarget, AppSize.touchTarget),
                      ],
                    ),
                  ),
                },
              ),
          ],
        ),
      ),
    );
  }

  static Widget _block(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.xs),
    ),
  );
}
