import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/mdi_icons.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 모든 화면의 상단 줄: [←] 제목 (오른쪽 버튼). 제목은 왼쪽 정렬이고 아래에 1px 흰 구분선(RN `ScreenHeader`).
class ScreenHeader extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    this.titleAccessory,
    this.showBack = true,
    this.onBack,
    this.actions = const [],
    this.compact = false,
  });

  final String title;

  /// 제목 바로 오른쪽 표시(C의 🔔). 제목이 길면 제목만 줄인다.
  final Widget? titleAccessory;

  /// A·첫 실행 B-b처럼 돌아갈 곳이 없는 화면은 끈다.
  final bool showBack;

  /// 기본은 `Navigator.maybePop`.
  final VoidCallback? onBack;
  final List<Widget> actions;

  /// 가로 모드처럼 세로 공간이 좁을 때 버튼 높이·제목 글자를 줄인다.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.barSeparator)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              if (showBack)
                HeaderIconButton(
                  icon: MdiIcons.arrowLeft,
                  label: l10n.back,
                  compact: compact,
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                )
              else
                const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Row(
                  spacing: AppSpacing.xs,
                  children: [
                    Flexible(
                      child: Semantics(
                        header: true,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: compact
                                ? AppFontSize.body
                                : AppFontSize.title,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ?titleAccessory,
                  ],
                ),
              ),
              // 버튼이 없어도 줄 높이를 지킨다
              SizedBox(
                height: compact ? 32 : AppSize.touchTarget,
                child: Row(children: actions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// title-bar 아이콘 버튼. 누르면 선택 햅틱(D-109). [badge]가 있으면 아이콘 오른쪽 위에 빨간 점을 그리고
/// 그 문구를 스크린 리더 힌트로 읽는다(D-124).
class HeaderIconButton extends StatelessWidget {
  const new({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.compact = false,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool compact;
  final String? badge;

  static const _badgeSize = 9.0;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    hint: badge,
    excludeSemantics: true,
    child: InkResponse(
      onTap: () {
        tapHaptic();
        onPressed();
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: AppSize.touchTarget,
          minHeight: compact ? 32 : AppSize.touchTarget,
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: AppFontSize.headline, color: AppColors.text),
              if (badge != null)
                Positioned(
                  key: const Key('header-badge'),
                  top: -2,
                  right: -3,
                  child: Container(
                    width: _badgeSize,
                    height: _badgeSize,
                    // 배경색 테두리로 아이콘 선과 떼어 보이게 한다.
                    // Border 기본 색이 검정이라 AppColors.background와 같다
                    decoration: BoxDecoration(
                      color: AppColors.badge,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A·C title-bar의 [⚙]. 이 기기의 알림 대상 원자재가 없으면(B 알림 행 "끔") 빨간 점을 띄운다.
/// 설정을 받기 전이나 조회가 실패하면 점을 띄우지 않는다(D-124).
class SettingsHeaderButton extends ConsumerWidget {
  const new({super.key, required this.onPressed, this.compact = false});

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsViewProvider).value;
    final alertOff = settings != null && settings.alertCommodity == null;
    return HeaderIconButton(
      icon: MdiIcons.cogOutline,
      label: l10n.settingsTitle,
      compact: compact,
      badge: alertOff ? l10n.settingsAlertOffBadge : null,
      onPressed: onPressed,
    );
  }
}

/// 이 기기의 알림 대상 원자재 표시(A 목록 이름 아래, C title-bar 제목 옆). 크기는 두 곳이 같다.
class AlertBell extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).commodityListAlert,
    excludeSemantics: true,
    child: const Text('🔔', style: TextStyle(fontSize: AppFontSize.caption)),
  );
}
