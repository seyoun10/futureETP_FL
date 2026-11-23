import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/etp.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_amount.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/core/widgets/segmented_control.dart';
import 'package:futureetp/features/commodity/chart_tab.dart';
import 'package:futureetp/features/commodity/etp/etp_list_model.dart';
import 'package:futureetp/features/commodity/etp/etp_provider.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 배수 선택지가 이보다 많으면 이름을 위에 두고 전체 폭을 쓴다.
const _inlineLeverageOptions = 4;

/// C-d ETP 목록 탭(screens.md C-d, RN `EtpListScreen`).
/// 필터·정렬은 받은 목록 안에서 하고, 이 탭 State에만 두어 기억하지 않는다(D-017).
/// 수집 시각은 C 껍데기의 기준 시각 줄이 보여 준다.
class EtpListTab extends ConsumerStatefulWidget {
  const new({super.key, required this.codeText, required this.onOpenEtp});

  /// 경로의 원자재 코드. 모르는 값이면 NOT_FOUND 문구다.
  final String codeText;

  /// 행을 누르면 C-d-a로 간다(ETP id).
  final ValueChanged<String> onOpenEtp;

  @override
  ConsumerState<EtpListTab> createState() => _EtpListTabState();
}

class _EtpListTabState extends ConsumerState<EtpListTab> {
  EtpFilters _filters = noEtpFilters;
  EtpSort _sort = EtpSort.byDefault;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = CommodityCode.fromWire(widget.codeText);
    if (code == null) {
      return TabMessage(errorText(l10n, const AppError(AppErrorCode.notFound)));
    }
    final provider = etpListProvider(code);
    return ColoredBox(
      color: AppColors.background,
      child: QueryStateView(
        value: ref.watch(provider),
        onRetry: () => ref.invalidate(provider),
        builder: (context, data) {
          if (data.etps.isEmpty) return _Message(l10n.etpEmpty);
          // RN `localeCompare`는 앱 언어가 아니라 기기 로캘을 따른다
          final hangulFirst =
              View.of(context).platformDispatcher.locale.languageCode == 'ko';
          final rows = sortEtps(
            filterEtps(data.etps, _filters),
            _sort,
            hangulFirst: hangulFirst,
          );
          return ListView.builder(
            key: const Key('etp-list'),
            // 기본값이면 상단 안전 영역만큼 띄운다. 탭 안이라 띄우지 않는다
            padding: EdgeInsets.zero,
            itemCount: rows.isEmpty ? 2 : rows.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return _Filters(
                  etps: data.etps,
                  filters: _filters,
                  sort: _sort,
                  onFiltersChanged: (f) => setState(() => _filters = f),
                  onSortChanged: (s) => setState(() => _sort = s),
                );
              }
              if (rows.isEmpty) return _Message(l10n.etpNoMatch);
              final etp = rows[i - 1];
              return _EtpRow(
                etp: etp,
                sort: _sort,
                onTap: () {
                  tapHaptic();
                  widget.onOpenEtp(etp.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.xl),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppFontSize.body,
      ),
    ),
  );
}

/// 시장·유형·배수·환헤지 필터와 정렬. 모두 세그먼트 버튼이다.
class _Filters extends StatelessWidget {
  const new({
    required this.etps,
    required this.filters,
    required this.sort,
    required this.onFiltersChanged,
    required this.onSortChanged,
  });

  final List<EtpSummary> etps;
  final EtpFilters filters;
  final EtpSort sort;
  final ValueChanged<EtpFilters> onFiltersChanged;
  final ValueChanged<EtpSort> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final leverages = leverageOptions(etps);
    final f = filters;
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.separator)),
      ),
      child: Column(
        children: [
          SegmentedControl<EtpMarket?>(
            key: const Key('etp-filter-market'),
            label: l10n.etpMarket,
            options: [
              (value: null, label: l10n.etpAll),
              for (final m in EtpMarket.values)
                (value: m, label: marketText(m)),
            ],
            value: f.market,
            onChanged: (market) => onFiltersChanged((
              market: market,
              type: f.type,
              leverage: f.leverage,
              fxHedge: f.fxHedge,
            )),
          ),
          SegmentedControl<EtpType?>(
            key: const Key('etp-filter-type'),
            label: l10n.etpType,
            options: [
              (value: null, label: l10n.etpAll),
              for (final t in EtpType.values) (value: t, label: typeText(t)),
            ],
            value: f.type,
            onChanged: (type) => onFiltersChanged((
              market: f.market,
              type: type,
              leverage: f.leverage,
              fxHedge: f.fxHedge,
            )),
          ),
          SegmentedControl<double?>(
            key: const Key('etp-filter-leverage'),
            label: l10n.etpLeverage,
            options: [
              (value: null, label: l10n.etpAll),
              for (final n in leverages)
                (value: n, label: l10n.etpLeverageValue(plainNumber(n))),
            ],
            value: f.leverage,
            onChanged: (leverage) => onFiltersChanged((
              market: f.market,
              type: f.type,
              leverage: leverage,
              fxHedge: f.fxHedge,
            )),
            stacked: leverages.length > _inlineLeverageOptions,
          ),
          SegmentedControl<FxHedge?>(
            key: const Key('etp-filter-fx-hedge'),
            label: l10n.etpFxHedge,
            options: [
              (value: null, label: l10n.etpAll),
              for (final h in FxHedge.values)
                (value: h, label: fxHedgeText(l10n, h)),
            ],
            value: f.fxHedge,
            onChanged: (fxHedge) => onFiltersChanged((
              market: f.market,
              type: f.type,
              leverage: f.leverage,
              fxHedge: fxHedge,
            )),
            stacked: true,
          ),
          SegmentedControl<EtpSort>(
            key: const Key('etp-sort'),
            label: l10n.etpSort,
            options: [
              for (final s in EtpSort.values)
                (value: s, label: sortText(l10n, s)),
            ],
            value: sort,
            onChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}

/// 행: 이름(미국 상장은 티커 + 이름) / `시장 · 유형 · 배수 · 환헤지[ · 정렬 값]` >.
class _EtpRow extends StatelessWidget {
  const new({required this.etp, required this.sort, required this.onTap});

  final EtpSummary etp;
  final EtpSort sort;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ticker = etp.tickers.firstOrNull;
    final title = etp.market == EtpMarket.us && ticker != null
        ? '$ticker  ${etp.name}'
        : etp.name;
    final (:hasValue, :value) = sortValue(etp, sort);
    final attrs = [
      marketText(etp.market),
      typeText(etp.type),
      l10n.etpLeverageValue(plainNumber(etp.leverage)),
      fxHedgeText(l10n, etp.fxHedge),
      if (hasValue)
        l10n.etpSortValue(
          sortText(l10n, sort),
          value == null ? l10n.etpNoValue : amountText(l10n, etp.market, value),
        ),
    ];
    return InkWell(
      key: Key('etp-${etp.id}'),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.separator)),
        ),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: AppFontSize.body,
                    ),
                  ),
                  Text(
                    attrs.join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    );
  }
}

/// 시장 표기(`KRX`·`US`). 언어와 상관없이 같다.
String marketText(EtpMarket market) => market.name.toUpperCase();

/// 유형 표기(`ETF`·`ETN`).
String typeText(EtpType type) => type.name.toUpperCase();

/// 환헤지 표기. C-d와 C-d-a에서 같게 쓴다(screens.md C-d).
String fxHedgeText(AppLocalizations l10n, FxHedge hedge) => switch (hedge) {
  FxHedge.hedged => l10n.etpFxHedged,
  FxHedge.unhedged => l10n.etpFxUnhedged,
  FxHedge.na => l10n.etpFxNa,
};

String sortText(AppLocalizations l10n, EtpSort sort) => switch (sort) {
  EtpSort.byDefault => l10n.etpSortDefault,
  EtpSort.aum => l10n.etpSortAum,
  EtpSort.tradingValue => l10n.etpSortTradingValue,
};

/// 순자산·거래대금 금액. 원화는 언어별 줄임 방식, 달러는 언어와 상관없이 K·M·B다.
String amountText(AppLocalizations l10n, EtpMarket market, double value) =>
    switch (market) {
      EtpMarket.krx => l10n.etpAmountKrx(
        compactAmount(
          value,
          l10n.etpKrwScheme == 'si' ? AmountScheme.si : AmountScheme.eok,
        ),
      ),
      EtpMarket.us => l10n.etpAmountUs(compactAmount(value, AmountScheme.si)),
    };
