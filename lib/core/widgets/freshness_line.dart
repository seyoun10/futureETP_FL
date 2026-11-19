import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/widgets/footer_line.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// A·C 화면 최하단 기준 시각 줄: `10/22 09:00 기준 · 거래일 10/22 · 지연 · 장중`
/// (screens.md 공통 규칙, RN `FreshnessLine`).
///
/// 새로고침이 실패해도 마지막 데이터의 기준 시각을 그대로 보여 줘 오래됨을 알린다.
class FreshnessLine extends StatelessWidget {
  /// 거래일·지연·장 상태까지 쓴다.
  new(Freshness this.freshness, {super.key}) : asOf = freshness.asOf;

  /// 기준 시각만 쓴다(C-d ETP 목록의 수집 시각).
  const new asOfOnly(this.asOf, {super.key}) : freshness = null;

  final DateTime asOf;
  final Freshness? freshness;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      l10n.freshnessAsOf(formatLocalDateTime(asOf)),
      if (freshness case final f?) ...[
        l10n.freshnessTradeDate(formatTradeDate(f.tradeDate)),
        if (f.delayed) l10n.freshnessDelayed,
        switch (f.marketState) {
          MarketState.open => l10n.marketStateOpen,
          MarketState.closed => l10n.marketStateClosed,
          MarketState.settlementPending => l10n.marketStateSettlementPending,
        },
      ],
    ];
    return FooterText(items.join(' · '));
  }
}

/// 화면 최하단 기준 시각 줄. [line]이 없어도(탭 전환 중·첫 조회 중·ETP 수집 전)
/// 빈 줄로 자리를 지킨다.
class FreshnessFooter extends StatelessWidget {
  const new({super.key, this.line});

  final FreshnessLine? line;

  @override
  Widget build(BuildContext context) => FooterLine(child: line);
}
