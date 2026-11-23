import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/models/commodities.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/failed_alert.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/core/widgets/freshness_line.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/features/commodity_list/commodity_list_provider.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 당겨서 새로고침이 이 시간 안에 끝나지 않으면 인디케이터를 거두고 안내를 띄운다(D-138).
const pullRefreshTimeout = Duration(seconds: 5);

/// A 원자재 목록(screens.md A, D-085, RN `CommodityListScreen`).
/// 원자재와 월물 줄은 서버가 준 순서대로 그린다.
class CommodityListScreen extends ConsumerStatefulWidget {
  const new({
    super.key,
    required this.onOpenSettings,
    required this.onOpenCalendar,
    required this.onOpenCommodity,
  });

  /// [⚙]. 라우트는 앱 계층이 갖는다.
  final VoidCallback onOpenSettings;

  /// [📅] A-a 휴장 달력(D-143). [⚙] 바로 왼쪽이다.
  final VoidCallback onOpenCalendar;

  /// 행을 누르면 C(C-a 탭)로 간다. 인자는 경로 코드(`GC`).
  final ValueChanged<String> onOpenCommodity;

  @override
  ConsumerState<CommodityListScreen> createState() =>
      _CommodityListScreenState();
}

class _CommodityListScreenState extends ConsumerState<CommodityListScreen> {
  var _refreshing = false;

  // 시간 초과로 거둔 회차의 늦은 응답이 상태를 다시 바꾸지 않게 회차를 센다
  var _run = 0;

  /// 당겨서 새로고침(D-138). 걸리는 순간 햅틱, 조회가 끝날 때까지 인디케이터를 두고 화면 터치를 막는다.
  /// 시간 초과·실패면 공통 실패 Alert. 늦게 끝난 조회는 그대로 목록을 바꾼다(Provider가 갖는다).
  /// 자동 새로고침·복귀 재조회는 인디케이터 없이 조용히 한다.
  Future<void> _onRefresh() {
    final id = ++_run;
    final done = Completer<void>();
    refreshHaptic();
    setState(() => _refreshing = true);

    void finish({required bool failed}) {
      if (_run != id) return;
      _run++;
      done.complete();
      if (!mounted) return;
      setState(() => _refreshing = false);
      if (failed) {
        final l10n = AppLocalizations.of(context);
        showFailedAlert(
          context,
          l10n.commodityListRefreshFailedTitle,
          l10n.commodityListRefreshFailedMessage,
        );
      }
    }

    final timer = Timer(pullRefreshTimeout, () => finish(failed: true));
    unawaited(
      ref
          .refresh(commodityListProvider.future)
          .then(
            (_) => finish(failed: false),
            onError: (Object _) => finish(failed: true),
          )
          .whenComplete(timer.cancel),
    );
    return done.future;
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(commodityListProvider);
    final palette = ref.watch(upDownPaletteProvider);
    final l10n = AppLocalizations.of(context);
    // 새로고침 중에는 헤더까지 터치를 막는다. 목록 위 인디케이터는 그대로 보인다
    return AbsorbPointer(
      absorbing: _refreshing,
      child: Scaffold(
        body: Column(
          children: [
            ScreenHeader(
              title: 'futureETP',
              showBack: false,
              actions: [
                HeaderIconButton(
                  icon: Icons.calendar_month_outlined,
                  label: l10n.calendarOpen,
                  onPressed: widget.onOpenCalendar,
                ),
                SettingsHeaderButton(onPressed: widget.onOpenSettings),
              ],
            ),
            Expanded(
              child: QueryStateView(
                value: query,
                onRetry: () => ref.invalidate(commodityListProvider),
                builder: (context, data) => RefreshIndicator.adaptive(
                  onRefresh: _onRefresh,
                  color: AppColors.textSecondary,
                  child: ListView.builder(
                    key: const Key('commodity-list'),
                    // 목록이 짧아도 당길 수 있게 한다
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: data.commodities.length,
                    itemBuilder: (context, i) => _CommodityRow(
                      commodity: data.commodities[i],
                      palette: palette,
                      onTap: () {
                        tapHaptic();
                        widget.onOpenCommodity(data.commodities[i].code.wire);
                      },
                    ),
                  ),
                ),
              ),
            ),
            FreshnessFooter(
              line: switch (query.value) {
                final data? => FreshnessLine(data.freshness),
                null => null,
              },
            ),
          ],
        ),
      ),
    );
  }
}

const _figures = [FontFeature.tabularFigures()];

class _CommodityRow extends StatelessWidget {
  const new({
    required this.commodity,
    required this.palette,
    required this.onTap,
  });

  final CommodityQuotes commodity;
  final UpDownPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = commodity.code.wire;
    return InkWell(
      key: Key('commodity-$code'),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.separator)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 104,
              child: Column(
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    '${l10n.commodityName(code)}\n($code)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: AppFontSize.body,
                    ),
                  ),
                  if (commodity.alert) const AlertBell(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: AppSpacing.xs,
                children: [
                  for (final quote in commodity.contracts)
                    _QuoteLine(
                      quote: quote,
                      decimals: commodity.priceDecimals,
                      palette: palette,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 월물 / 현재가 / 전일 대비 / 등락률. 오늘 값이 없으면 마지막 정산가와 "거래 없음"이다.
class _QuoteLine extends StatelessWidget {
  const new({
    required this.quote,
    required this.decimals,
    required this.palette,
  });

  final ContractQuote quote;
  final int decimals;
  final UpDownPalette palette;

  @override
  Widget build(BuildContext context) {
    final change = quote.change;
    final color = quote.noTrade || change == null
        ? AppColors.neutral
        : changePairColor(change, quote.changePct ?? 0, decimals, palette);
    Widget cell(String text, Color color, {double? width}) {
      final t = Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          color: color,
          fontSize: AppFontSize.caption,
          fontFeatures: _figures,
        ),
      );
      return width == null
          ? Expanded(child: t)
          : SizedBox(width: width, child: t);
    }

    return Row(
      children: [
        cell(
          formatContractMonth(quote.contractMonth) +
              (quote.isFront ? '●' : ' '),
          AppColors.textSecondary,
          width: 52,
        ),
        cell(switch (quote.price) {
          final p? => formatPrice(p, decimals),
          null => '-',
        }, AppColors.text),
        if (quote.noTrade)
          cell(
            AppLocalizations.of(context).commodityListNoTrade,
            AppColors.neutral,
            width: 124,
          )
        else ...[
          cell(
            change == null ? '-' : formatChange(change, decimals),
            color,
            width: 64,
          ),
          cell(
            switch (quote.changePct) {
              final p? => formatChangePct(p),
              null => '-',
            },
            color,
            width: 60,
          ),
        ],
      ],
    );
  }
}
