import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/models/etp.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/features/commodity/etp/etp_list_model.dart';
import 'package:futureetp/features/commodity/etp/etp_list_tab.dart';
import 'package:futureetp/features/commodity/etp/etp_provider.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 외부 페이지를 연다. 테스트에서 바꾼다.
typedef UrlOpener = Future<void> Function(Uri url);

/// C-d-a ETP 상세(screens.md C-d-a, RN `EtpDetailScreen`). C 탭 밖 스택이다(D-047).
/// 값은 자동 수집 정보라 원문 언어 그대로 보여 준다.
class EtpDetailScreen extends ConsumerWidget {
  const new({super.key, required this.id, required this.openUrl});

  final String id;
  final UrlOpener openUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = etpDetailProvider(id);
    final value = ref.watch(provider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScreenHeader(title: value.value?.name ?? l10n.etpDetailTitle),
          Expanded(
            child: QueryStateView(
              value: value,
              onRetry: () => ref.invalidate(provider),
              builder: (context, etp) => _Fields(etp: etp, openUrl: openUrl),
            ),
          ),
        ],
      ),
    );
  }
}

/// 수집한 주소라도 웹 페이지만 연다.
Uri? _webUrl(String? url) {
  if (url == null) return null;
  final uri = Uri.tryParse(url);
  return uri != null && (uri.scheme == 'https' || uri.scheme == 'http')
      ? uri
      : null;
}

class _Fields extends StatelessWidget {
  const new({required this.etp, required this.openUrl});

  final EtpDetail etp;
  final UrlOpener openUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String orDash(String? value) => value ?? l10n.etpNoValue;
    final issuerUrl = _webUrl(etp.issuerUrl);
    const note = TextStyle(
      color: AppColors.textSecondary,
      fontSize: AppFontSize.caption,
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final (label, value) in [
          (l10n.etpCommodity, l10n.commodityName(etp.commodityCode.wire)),
          (l10n.etpMarket, marketText(etp.market)),
          (l10n.etpType, typeText(etp.type)),
          (l10n.etpLeverage, l10n.etpLeverageValue(plainNumber(etp.leverage))),
          (l10n.etpFxHedge, fxHedgeText(l10n, etp.fxHedge)),
          (l10n.etpIssuer, orDash(etp.issuer)),
          (l10n.etpUnderlyingIndex, orDash(etp.underlyingIndex)),
          (
            l10n.etpExpenseRatio,
            switch (etp.expenseRatio) {
              null => l10n.etpNoValue,
              final n => l10n.etpExpenseRatioValue(plainNumber(n)),
            },
          ),
          (l10n.etpListedDate, orDash(etp.listedDate)),
          (
            l10n.etpTicker,
            etp.series.isEmpty
                ? l10n.etpNoValue
                : [for (final s in etp.series) seriesLine(l10n, s)].join('\n'),
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _Field(label: label, value: value),
          ),
        if (issuerUrl != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Semantics(
                link: true,
                child: TextButton(
                  key: const Key('etp-open-issuer'),
                  onPressed: () => unawaited(openUrl(issuerUrl)),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.text,
                    minimumSize: const Size(0, AppSize.touchTarget),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    textStyle: const TextStyle(fontSize: AppFontSize.body),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                  child: Text(l10n.etpOpenIssuer),
                ),
              ),
            ),
          ),
        Text(l10n.etpSourceNote, style: note),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.freshnessAsOf(formatLocalDateTime(etp.collectedAt)),
          style: note,
        ),
      ],
    );
  }
}

/// ETN 후속 시리즈는 줄마다 `B 시리즈 · 530031 · 만기 2031-03-15`
/// (screens.md C-d-a). ETF는 종목코드만.
String seriesLine(AppLocalizations l10n, EtpSeries s) => [
  if (s.seriesCode case final code?) l10n.etpSeriesCode(code),
  s.ticker,
  if (s.maturityDate case final date?) l10n.etpMaturity(date),
].join(' · ');

class _Field extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: AppFontSize.body);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: style.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(value, style: style.copyWith(color: AppColors.text)),
        ),
      ],
    );
  }
}
