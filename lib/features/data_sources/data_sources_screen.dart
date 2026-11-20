import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/core/widgets/section_header.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// B > 데이터 출처(screens.md B, RN `DataSourcesScreen`). 업체 약관의 출처 표기를 지키는
/// 읽기 전용 화면이다. 상표·로고 없이 이름만 쓴다. 줄 순서는 screens.md 그대로이고,
/// 소스가 바뀌면 문구도 바꾼다.
class DataSourcesScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sections = [
      (
        l10n.dataSourcesFutures,
        [
          (l10n.dataSourcesExchangeLabel, l10n.dataSourcesExchangeValue),
          (l10n.dataSourcesSettlementLabel, l10n.dataSourcesSettlementValue),
          (l10n.dataSourcesIntradayLabel, l10n.dataSourcesIntradayValue),
          (l10n.dataSourcesHistoryLabel, l10n.dataSourcesHistoryValue),
        ],
      ),
      (
        l10n.dataSourcesEtp,
        [
          (l10n.dataSourcesEtpKrLabel, l10n.dataSourcesEtpKrValue),
          (l10n.dataSourcesEtpUsLabel, l10n.dataSourcesEtpUsValue),
        ],
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScreenHeader(title: l10n.settingsDataSources),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                for (final (title, rows) in sections) ...[
                  SectionHeader(title),
                  for (final (label, value) in rows) _Row(label, value),
                ],
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    l10n.dataSourcesNotice,
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

class _Row extends StatelessWidget {
  const new(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.separator)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppFontSize.body,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: AppFontSize.body,
            ),
          ),
        ),
      ],
    ),
  );
}
