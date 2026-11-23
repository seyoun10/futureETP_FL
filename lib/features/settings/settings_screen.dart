import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/config/app_config.dart';
import 'package:futureetp/core/config/app_version.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/failed_alert.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/core/widgets/footer_line.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/core/widgets/section_header.dart';
import 'package:futureetp/core/widgets/segmented_control.dart';
import 'package:futureetp/features/settings/rare_levels_input.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// B 설정(screens.md B, RN `SettingsScreen`). 표시 설정은 기기에, 이격도차트·알림 설정은 서버에
/// 기기별로 저장한다(D-073, D-120). 고르면 바로 그 필드만 저장하고(낙관적, D-082),
/// 실패하면 화면 위에 오류 줄을 띄운다.
class SettingsScreen extends ConsumerStatefulWidget {
  const new({
    super.key,
    required this.onOpenAlerts,
    required this.onOpenAccessKey,
    required this.onOpenDataSources,
  });

  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenAccessKey;
  final VoidCallback onOpenDataSources;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// 이 화면에서 마지막으로 저장한 것의 실패. 새로 저장하면 지운다.
  Object? _saveError;

  void _save(SettingsPatch patch) {
    setState(() => _saveError = null);
    unawaited(
      ref.read(deviceSettingsProvider.notifier).save(patch).then((error) {
        if (mounted) setState(() => _saveError = error);
      }),
    );
  }

  /// 표시·이격도차트 설정만 기본값으로 되돌린다. 알림(B-a)과 접근 키는 그대로 둔다.
  void _reset() {
    final display = DisplaySettings.fromDevice(ref.read(deviceLocaleProvider));
    ref.read(displaySettingsProvider.notifier)
      ..setLanguage(display.language)
      ..setUpDownStyle(display.upDownStyle);
    const d = disparitySettingsDefaults;
    _save(
      SettingsPatch(
        basis: d.basis,
        maPeriod: d.maPeriod,
        window: d.window,
        rareLevels: d.rareLevels,
        locale: display.language,
      ),
    );
  }

  Future<void> _confirmReset() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(l10n.settingsResetTitle),
        content: Text(l10n.settingsResetMessage),
        actions: [
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.settingsReset,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (ok ?? false) _reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsViewProvider);
    final hasKey = ref.watch(accessKeyProvider.select((s) => s.hasKey));
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      backgroundColor: AppColors.background,
      // 앱 버전 줄은 키패드가 덮는다. 목록만 키패드만큼 아래를 비운다
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              ScreenHeader(
                title: l10n.settingsTitle,
                actions: [
                  HeaderIconButton(
                    icon: Icons.restart_alt,
                    label: l10n.settingsReset,
                    onPressed: () => unawaited(_confirmReset()),
                  ),
                ],
              ),
              Expanded(
                // 끌거나 빈 곳을 누르면 키패드를 닫는다. 키패드가 열린 채 다른 행을 누르면
                // 그 행이 눌리고 키패드는 그대로다(RN keyboardShouldPersistTaps="handled")
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      bottom: keyboard > 0 ? keyboard + AppSize.touchTarget : 0,
                    ),
                    children: [
                      if (_saveError case final error?)
                        SaveErrorLine(
                          l10n.settingsSaveFailed(errorText(l10n, error)),
                        ),
                      ..._displaySection(l10n),
                      SectionHeader(l10n.settingsSectionDisparity),
                      if (settings case AsyncError(
                        :final error,
                        hasValue: false,
                        isLoading: false,
                      ))
                        ErrorView(
                          error: error,
                          onRetry: () => ref.invalidate(deviceSettingsProvider),
                        )
                      else
                        ..._disparitySection(l10n, settings.value),
                      SectionHeader(l10n.settingsSectionOther),
                      LinkRow(
                        label: l10n.settingsAccessKey,
                        value: hasKey ? l10n.settingsAccessKeySaved : null,
                        description: l10n.settingsAccessKeyDesc,
                        onTap: widget.onOpenAccessKey,
                      ),
                      LinkRow(
                        label: l10n.settingsDataSources,
                        description: l10n.settingsDataSourcesDesc,
                        onTap: widget.onOpenDataSources,
                      ),
                    ],
                  ),
                ),
              ),
              const FooterLine(child: _AppVersionText()),
            ],
          ),
          // iOS 숫자 키패드에는 닫는 키가 없어 키패드 위에 [완료] 줄을 둔다
          if (ios && keyboard > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: keyboard,
              child: _KeyboardDoneBar(label: l10n.done),
            ),
        ],
      ),
    );
  }

  /// 언어·등락 색은 기기 설정이다. 언어는 푸시 문구에 쓰므로 서버에도 보낸다(D-082).
  List<Widget> _displaySection(AppLocalizations l10n) {
    final display = ref.watch(displaySettingsProvider);
    final notifier = ref.read(displaySettingsProvider.notifier);
    return [
      SectionHeader(l10n.settingsSectionGeneral),
      SegmentedControl<AppLanguage>(
        label: l10n.settingsLanguage,
        options: [
          (value: AppLanguage.ko, label: l10n.settingsLanguageKo),
          (value: AppLanguage.en, label: l10n.settingsLanguageEn),
        ],
        value: display.language,
        description: l10n.settingsLanguageDesc,
        onChanged: (language) {
          notifier.setLanguage(language);
          _save(SettingsPatch(locale: language));
        },
      ),
      SegmentedControl<UpDownStyle>(
        label: l10n.settingsUpDownStyle,
        options: [
          (value: UpDownStyle.kr, label: l10n.settingsUpDownStyleKr),
          (value: UpDownStyle.us, label: l10n.settingsUpDownStyleUs),
        ],
        value: display.upDownStyle,
        description: l10n.settingsUpDownStyleDesc,
        onChanged: notifier.setUpDownStyle,
      ),
    ];
  }

  /// 조회 중에는 아무것도 고르지 않은 채로 보여 준다. 알림 행은 B-a로 간다.
  List<Widget> _disparitySection(
    AppLocalizations l10n,
    DeviceSettings? settings,
  ) => [
    SegmentedControl<Basis?>(
      label: l10n.settingsBasis,
      options: [
        (value: Basis.front, label: l10n.basisFront),
        (value: Basis.kr, label: l10n.basisKr),
        (value: Basis.us, label: l10n.basisUs),
      ],
      value: settings?.basis,
      description: l10n.settingsBasisDesc,
      onChanged: (basis) => _save(SettingsPatch(basis: basis)),
    ),
    SegmentedControl<MaPeriod?>(
      label: l10n.settingsMaPeriod,
      options: [
        for (final p in MaPeriod.values) (value: p, label: '${p.days}'),
      ],
      value: settings?.maPeriod,
      description: l10n.settingsMaPeriodDesc,
      onChanged: (maPeriod) => _save(SettingsPatch(maPeriod: maPeriod)),
    ),
    SegmentedControl<DistributionWindow?>(
      label: l10n.settingsWindow,
      options: [
        for (final w in DistributionWindow.values)
          (value: w, label: windowLabel(l10n, w)),
      ],
      value: settings?.window,
      description: l10n.settingsWindowDesc,
      onChanged: (window) => _save(SettingsPatch(window: window)),
    ),
    RareLevelsInput(
      levels: settings?.rareLevels,
      description: l10n.settingsRareLevelsDesc,
      onSave: (rareLevels) => _save(SettingsPatch(rareLevels: rareLevels)),
    ),
    LinkRow(
      label: l10n.settingsAlerts,
      value: settings == null
          ? null
          : switch (settings.alertCommodity) {
              final code? => l10n.commodityName(code.wire),
              null => l10n.settingsAlertOff,
            },
      description: l10n.settingsAlertsDesc,
      onTap: widget.onOpenAlerts,
    ),
  ];
}

/// 분포 기간 칸 글자: 년 수, 전체.
String windowLabel(AppLocalizations l10n, DistributionWindow window) =>
    switch (window) {
      DistributionWindow.y3 => '3',
      DistributionWindow.y5 => '5',
      DistributionWindow.y10 => '10',
      DistributionWindow.all => l10n.settingsWindowAll,
    };

/// 설치한 빌드(OTA가 없어 RN 앱 번들 줄 대신, FL-031).
class _AppVersionText extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(appVersionProvider).value;
    final variant = ref.watch(appConfigProvider).variant.name;
    return FooterText(
      version == null
          ? ' '
          : AppLocalizations.of(context)
                .settingsAppVersion(version.version, version.build, variant),
    );
  }
}

/// 이름 + 값 + › 행. 설명은 이름·값 아래 한 줄이다. 누르면 선택 햅틱(D-109).
class LinkRow extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.description,
  });

  final String label;
  final String? value;
  final String? description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: InkWell(
      onTap: () {
        tapHaptic();
        onTap();
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSize.touchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.separator)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: AppFontSize.body,
                          ),
                        ),
                      ),
                      if (value case final v?)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: Text(
                            v,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppFontSize.body,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (description case final d?)
                    Text(
                      d,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppFontSize.caption,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    ),
  );
}

/// 키패드 위 [완료] 줄(iOS). 누르면 키패드를 닫고, 닫히면 rare-level을 검증·저장한다.
class _KeyboardDoneBar extends StatelessWidget {
  const new({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
    ),
    // RN처럼 위아래 8만 두어 낮게 그린다. 누르는 영역은 줄 전체다
    child: Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
