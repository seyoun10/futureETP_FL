import 'dart:math' as math;
import 'dart:typed_data';

import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:material_ui/material_ui.dart';

// C-c 응답 → 차트 입력·범례·롤 수익률(RN `contractChartModel.ts`). 모두 순수 함수다.

/// 대표월물 표식(A 원자재 목록과 같다).
const frontMark = '●';

/// 만기순 [index]번째 월물 선 색. 6번째부터는 마지막(회색) 색이다(D-118).
Color contractLineColor(int index) =>
    ChartColors.contractLines[math.min(
      index,
      ChartColors.contractLines.length - 1,
    )];

/// 차트 위 범례 한 칸.
typedef LegendItem = ({String label, Color color, bool isFront});

@immutable
class ContractModel {
  const new({
    required this.chart,
    required this.series,
    required this.legend,
    required this.widestLabels,
  });

  /// 날짜·월물이 없으면 null(값 없음 문구).
  static ContractModel? from(ContractsChart chart) {
    if (chart.dates.isEmpty || chart.contracts.isEmpty) return null;
    final lines = [
      for (final (i, c) in chart.contracts.indexed)
        // 굵기는 기본 1(RN `SERIES_STROKE`)
        ChartLine(
          Float64List.fromList([for (final p in c.prices) p ?? double.nan]),
          color: contractLineColor(i),
        ),
    ];
    final d = chart.priceDecimals;
    return ContractModel(
      chart: chart,
      series: ChartSeries(lines: lines),
      legend: [
        for (final (i, c) in chart.contracts.indexed)
          (
            label: formatContractMonth(c.contractMonth),
            color: contractLineColor(i),
            isFront: c.isFront,
          ),
      ],
      widestLabels: [for (final c in chart.contracts) ?_widest(c.prices, d)],
    );
  }

  final ContractsChart chart;
  final ChartSeries series;

  /// 만기순 선 색 범례.
  final List<LegendItem> legend;

  /// 선마다 글자가 가장 긴 값. 우측 y축 자리 너비를 이동해도 바꾸지 않게 잰다.
  final List<double> widestLabels;

  /// 보이는 범위 [first]~[last]에서 각 선의 마지막 값(D-093). 범위 안에 값이 없는 선은 없다.
  /// 월물은 차트 위 범례 색으로 구분한다(값만 쓴다, D-118).
  List<PriceLabel> endLabels(int first, int last) => [
    for (final (i, c) in chart.contracts.indexed)
      if (_lastValue(c.prices, first, last) case final p?)
        (price: p, color: contractLineColor(i)),
  ];

  static double? _lastValue(List<double?> values, int first, int last) {
    for (var i = math.min(last, values.length - 1); i >= first; i--) {
      if (values[i] case final v?) return v;
    }
    return null;
  }

  static double? _widest(List<double?> prices, int decimals) {
    final values = prices.nonNulls;
    if (values.isEmpty) return null;
    final min = values.reduce(math.min);
    final max = values.reduce(math.max);
    int len(double v) => formatPrice(v, decimals).length;
    return len(min) > len(max) ? min : max;
  }
}

/// 그날 양끝 월물(값이 있는 가장 가까운·먼 만기)의 연환산 롤 수익률(%).
/// `(near / far − 1) × 365 / 두 최종 거래일 사이 일수 × 100`. 양수 = 백워데이션(롤 이익),
/// C-b의 M1→M2 롤 수익률과 같은 식이다(D-118). 값이 있는 월물이 둘 미만이거나 값이 0 이하이거나
/// 최종 거래일이 같으면 null.
double? endsRollYieldPct(ContractsChart chart, int index) {
  final priced = [
    for (final c in chart.contracts)
      if (c.prices[index] case final p?)
        (price: p, lastTradeDate: c.lastTradeDate),
  ]..sort((a, b) => a.lastTradeDate.compareTo(b.lastTradeDate));
  if (priced.length < 2) return null;
  final near = priced.first;
  final far = priced.last;
  if (near.price <= 0 || far.price <= 0) return null;
  final days = _utcDate(far.lastTradeDate)
      .difference(_utcDate(near.lastTradeDate))
      .inDays;
  if (days <= 0) return null;
  return (near.price / far.price - 1) * 365 / days * 100;
}

DateTime _utcDate(String date) => DateTime.parse('${date}T00:00:00Z');
