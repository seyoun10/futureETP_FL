import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/push/push_permission.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/core/widgets/section_header.dart';
import 'package:futureetp/core/widgets/segmented_control.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 선택지 '없음'. 저장값은 alertCommodity null(알림 끔)이다.
/// null은 조회 중(고른 칸 없음)에 쓴다.
const _none = 'NONE';
const _commodityOptions = <Object>[_none, ...CommodityCode.values];

/// 알림 거부 시간을 켤 때 처음 값(screens.md B-a 예시).
const _defaultQuietTime = QuietTime(startMin: 23 * 60, endMin: 7 * 60);

/// 현지 자정 기준 분 → 24시간제 `HH:MM`.
String formatQuietMinute(int minute) =>
    '${(minute ~/ 60).toString().padLeft(2, '0')}:'
    '${(minute % 60).toString().padLeft(2, '0')}';

/// B-a 알림 설정(screens.md B-a, RN `AlertSettingsScreen`).
/// 바꾼 값은 바로 서버에 저장한다(D-082).
/// 적용 기준은 B 이격도차트 설정을 그대로 쓰므로 여기서는 요약만 보여 준다.
class AlertSettingsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AlertSettingsScreen> createState() =>
      _AlertSettingsScreenState();
}

class _AlertSettingsScreenState extends ConsumerState<AlertSettingsScreen> {
  Object? _saveError;

  void _save(SettingsPatch patch) {
    setState(() => _saveError = null);
    unawaited(
      ref.read(deviceSettingsProvider.notifier).save(patch).then((error) {
        if (mounted) setState(() => _saveError = error);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsViewProvider);
    final data = settings.value;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScreenHeader(title: l10n.alertSettingsTitle),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                const _PermissionBanner(),
                if (_saveError case final error?)
                  SaveErrorLine(
                    l10n.settingsSaveFailed(errorText(l10n, error)),
                  ),
                if (settings case AsyncError(
                  :final error,
                  hasValue: false,
                  isLoading: false,
                ))
                  ErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(deviceSettingsProvider),
                  )
                else ...[
                  SegmentedControl<Object?>(
                    stacked: true,
                    label: l10n.alertSettingsCommodity,
                    options: [
                      for (final code in _commodityOptions)
                        (
                          value: code,
                          label: code is CommodityCode
                              ? l10n.commodityName(code.wire)
                              : l10n.alertSettingsCommodityNone,
                        ),
                    ],
                    value: data == null ? null : data.alertCommodity ?? _none,
                    onChanged: (code) => _save(
                      SettingsPatch(
                        alertCommodity: PatchValue(
                          code is CommodityCode ? code : null,
                        ),
                      ),
                    ),
                  ),
                  if (data != null) ...[
                    _CriteriaSummary(settings: data),
                    _QuietTimeSection(
                      value: data.quietTime,
                      onChanged: (quietTime) => _save(
                        SettingsPatch(quietTime: PatchValue(quietTime)),
                      ),
                    ),
                  ],
                ],
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    l10n.alertSettingsGuide,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppFontSize.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 알림 권한 배너. 권한이 꺼져 있을 때만 보이고 확인 전에는 숨긴다(screens.md B-a).
/// 다시 물을 수 있으면 [허용](권한 창), 아니면 [설정 열기](OS 설정 화면)다.
class _PermissionBanner extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(pushPermissionProvider).value;
    if (permission == null || permission.granted) return const SizedBox();
    final l10n = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Expanded(
              child: Text(
                l10n.alertSettingsPermissionOff,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: AppFontSize.body,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                tapHaptic();
                unawaited(ref.read(pushPermissionProvider.notifier).request());
              },
              child: Text(
                permission.canAskAgain
                    ? l10n.alertSettingsPermissionAllow
                    : l10n.alertSettingsPermissionOpenSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 현재 적용 기준(B 이격도차트 설정 요약).
class _CriteriaSummary extends StatelessWidget {
  const new({required this.settings});

  final DeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final window = switch (settings.window) {
      DistributionWindow.y3 => l10n.alertSettingsCriteriaWindowYears('3'),
      DistributionWindow.y5 => l10n.alertSettingsCriteriaWindowYears('5'),
      DistributionWindow.y10 => l10n.alertSettingsCriteriaWindowYears('10'),
      DistributionWindow.all => l10n.settingsWindowAll,
    };
    final basis = switch (settings.basis) {
      Basis.front => l10n.basisFront,
      Basis.kr => l10n.basisKr,
      Basis.us => l10n.basisUs,
    };
    final levels = settings.rareLevels
        .map((v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v')
        .join('/');
    const style = TextStyle(color: AppColors.text, fontSize: AppFontSize.body);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.alertSettingsCriteria),
        for (final line in [
          l10n.alertSettingsCriteriaChart(
            basis,
            settings.maPeriod.days,
            window,
          ),
          l10n.alertSettingsCriteriaLevels(levels),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Text(line, style: style),
          ),
      ],
    );
  }
}

/// 알림 거부 시간(D-007, D-026, RN `QuietTimeSection`). 끄면 null로 저장한다.
/// 시작·종료는 30분 단위이고 서로 달라야 하므로 시트에서 반대쪽 시각은 고를 수 없다.
/// 자정을 넘기면 종료 시각에 '다음 날'을 붙인다.
class _QuietTimeSection extends StatelessWidget {
  const new({required this.value, required this.onChanged});

  final QuietTime? value;
  final ValueChanged<QuietTime?> onChanged;

  Future<void> _pick(BuildContext context, {required bool start}) async {
    final current = value;
    if (current == null) return;
    tapHaptic();
    final l10n = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.backdrop,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
      ),
      builder: (context) => _TimeSlotSheet(
        title: start
            ? l10n.alertSettingsQuietStart
            : l10n.alertSettingsQuietEnd,
        selected: start ? current.startMin : current.endMin,
        blocked: start ? current.endMin : current.startMin,
      ),
    );
    if (picked == null) return;
    final next = start
        ? current.copyWith(startMin: picked)
        : current.copyWith(endMin: picked);
    if (next != current) onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quiet = value;
    const secondary = TextStyle(
      color: AppColors.textSecondary,
      fontSize: AppFontSize.caption,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.alertSettingsQuietTime,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: AppFontSize.body,
                  ),
                ),
              ),
              Semantics(
                label: l10n.alertSettingsQuietTime,
                child: Switch.adaptive(
                  value: quiet != null,
                  activeTrackColor: AppColors.surfaceSelected,
                  inactiveTrackColor: AppColors.surface,
                  thumbColor: const WidgetStatePropertyAll(AppColors.text),
                  onChanged: (on) {
                    tapHaptic();
                    onChanged(on ? _defaultQuietTime : null);
                  },
                ),
              ),
            ],
          ),
        ),
        if (quiet != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                _TimeButton(
                  label: l10n.alertSettingsQuietStart,
                  time: formatQuietMinute(quiet.startMin),
                  onTap: () => unawaited(_pick(context, start: true)),
                ),
                const Text(
                  '~',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppFontSize.body,
                  ),
                ),
                _TimeButton(
                  label: l10n.alertSettingsQuietEnd,
                  time: quiet.startMin > quiet.endMin
                      ? l10n.alertSettingsQuietNextDay(
                          formatQuietMinute(quiet.endMin),
                        )
                      : formatQuietMinute(quiet.endMin),
                  onTap: () => unawaited(_pick(context, start: false)),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Text(l10n.alertSettingsQuietNote, style: secondary),
        ),
      ],
    );
  }
}

class _TimeButton extends StatelessWidget {
  const new({required this.label, required this.time, required this.onTap});

  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '$label $time',
    excludeSemantics: true,
    child: Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSize.touchTarget),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            time,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: AppFontSize.body,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    ),
  );
}

/// 30분 단위 48칸 중 하나를 누르면 바로 고르고 닫는다. [blocked]는 반대쪽 시각(시작≠종료)이다.
class _TimeSlotSheet extends StatelessWidget {
  const new({
    required this.title,
    required this.selected,
    required this.blocked,
  });

  final String title;
  final int selected;
  final int blocked;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: AppFontSize.title,
            ),
          ),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 2,
              children: [
                for (var m = 0; m <= quietMaxMin; m += quietStepMin)
                  _Slot(
                    minute: m,
                    selected: m == selected,
                    blocked: m == blocked,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Slot extends StatelessWidget {
  const new({
    required this.minute,
    required this.selected,
    required this.blocked,
  });

  final int minute;
  final bool selected;
  final bool blocked;

  @override
  Widget build(BuildContext context) => Semantics(
    inMutuallyExclusiveGroup: true,
    checked: selected,
    enabled: !blocked,
    button: true,
    child: Opacity(
      opacity: blocked ? 0.3 : 1,
      child: Material(
        color: selected ? AppColors.surfaceSelected : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          onTap: blocked
              ? null
              : () {
                  if (!selected) tapHaptic();
                  Navigator.of(context).pop(minute);
                },
          child: Center(
            child: Text(
              formatQuietMinute(minute),
              style: const TextStyle(
                color: AppColors.text,
                fontSize: AppFontSize.body,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
