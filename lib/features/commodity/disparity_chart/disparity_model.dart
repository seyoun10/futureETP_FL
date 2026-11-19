import 'dart:typed_data';

import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/candle_series.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:material_ui/material_ui.dart';

// C-a 응답 → 차트 입력(RN `disparitySeries.ts`·`disparityChartModel.ts`). 모두 순수 함수다.

const _maStroke = 2.5;

/// 십자선 상세에 쓰는 선 이름: 이평선, 또는 rare-level 방향·레벨.
sealed class LineLabel {
  const new();
}

final class MaLabel extends LineLabel {
  const new();
}

final class BandLabel extends LineLabel {
  const new(this.direction, this.level);

  final Direction direction;
  final double level;
}

/// 선과 그 이름.
typedef LabeledLine = ({ChartLine line, LineLabel label});

/// 보이는 봉의 최고가·최저가 봉과 현재가 기준 저점대비(LC)·고점대비(HC) %(screens.md C-a).
typedef VisibleStats = ({
  int highIndex,
  int lowIndex,
  double fromLowPct,
  double fromHighPct,
});

@immutable
class DisparityModel {
  const new({
    required this.bars,
    required this.series,
    required this.lines,
    required this.rollShading,
    required this.frontSwitchAt,
  });

  factory from(DisparityChart chart) {
    // 산출 불가일(OHLC 중 하나라도 없음)은 뺀다. x는 봉 순번이라 빈칸 없이 이어진다
    final bars = [
      for (final b in chart.bars)
        if (b.open != null &&
            b.high != null &&
            b.low != null &&
            b.close != null)
          b,
    ];
    Float64List column(double Function(DisparityBar b) pick) =>
        Float64List.fromList([for (final b in bars) pick(b)]);
    final ma = column((b) => b.ma ?? double.nan);

    // 응답은 방향마다 레벨 오름차순이라, 같은 방향 안에서 작은 레벨(드묾)일수록 순위가 높다.
    // 색은 레벨 값이 아니라 순위로 고른다(0 = 가장 덜 드묾, 옅음)
    final lines = <LabeledLine>[
      for (final level in chart.rareLevels)
        (
          line: ChartLine(
            Float64List.fromList([
              for (final m in ma) m * (1 + level.disparity / 100),
            ]),
            color: _bandColor(_rank(chart.rareLevels, level)),
          ),
          label: BandLabel(level.direction, level.level),
        ),
      // 이평선을 마지막에 그려 밴드 위에 오게 한다
      (
        line: ChartLine(ma, color: ChartColors.movingAverage, width: _maStroke),
        label: const MaLabel(),
      ),
    ];

    // 실제로 그린 기준값의 롤 정보만: 한국형·미국형은 음영, 대표월물은 전환일 세로 점선(D-103)
    final front = chart.basis == Basis.front;
    return DisparityModel(
      bars: bars,
      series: CandleSeries(
        opens: column((b) => b.open!),
        highs: column((b) => b.high!),
        lows: column((b) => b.low!),
        closes: column((b) => b.close!),
        lines: [for (final l in lines) l.line],
      ),
      lines: lines,
      rollShading: front ? const [] : rollSegments(bars),
      frontSwitchAt: front ? frontSwitches(bars) : const {},
    );
  }

  /// OHLC가 모두 있는 봉.
  final List<DisparityBar> bars;
  final CandleSeries series;

  /// [series]의 선과 같은 순서.
  final List<LabeledLine> lines;

  /// 롤 기간 음영 구간 [시작, 끝] 봉 순번(한국형·미국형).
  final List<(int, int)> rollShading;

  /// 대표월물 전환일 봉 순번 → 새 월물명(`FEB27`).
  final Map<int, String> frontSwitchAt;

  static int _rank(List<RareLevel> levels, RareLevel level) {
    final same = [
      for (final l in levels)
        if (l.direction == level.direction) l,
    ];
    return same.length - 1 - same.indexWhere((l) => l.level == level.level);
  }

  static Color _bandColor(int rank) {
    const colors = ChartColors.rareLevels;
    return colors[rank.clamp(0, colors.length - 1)];
  }
}

/// 롤 기간 음영 구간 [시작, 끝] 봉 순번.
List<(int, int)> rollSegments(List<DisparityBar> bars) {
  final segments = <(int, int)>[];
  for (var i = 0; i < bars.length; i++) {
    if (!bars[i].inRoll) continue;
    if (segments.isNotEmpty && segments.last.$2 == i - 1) {
      segments.last = (segments.last.$1, i);
    } else {
      segments.add((i, i));
    }
  }
  return segments;
}

/// 대표월물 전환일 → 새 월물명. 봉 t의 보유 월물은 t−1 종가 뒤 비중이라,
/// 보유 월물이 바뀐 봉의 바로 앞 봉(옛 월물의 마지막 날)이 전환일이다(D-103).
Map<int, String> frontSwitches(List<DisparityBar> bars) => {
  for (var i = 1; i < bars.length; i++)
    if (bars[i - 1].holdings.firstOrNull?.contractMonth case final prev?)
      if (bars[i].holdings.firstOrNull?.contractMonth case final cur?)
        if (prev != cur) i - 1: formatContractMonth(cur),
};

/// 보이는 봉 [i0, i1]의 최고가·최저가와 현재가(마지막 봉 종가) 기준 LC·HC.
VisibleStats? visibleStats(List<DisparityBar> bars, int i0, int i1) {
  if (bars.isEmpty || i0 > i1) return null;
  final current = bars.last.close!;
  var high = i0;
  var low = i0;
  for (var i = i0; i <= i1; i++) {
    if (bars[i].high! > bars[high].high!) high = i;
    if (bars[i].low! < bars[low].low!) low = i;
  }
  return (
    highIndex: high,
    lowIndex: low,
    fromLowPct: (current / bars[low].low! - 1) * 100,
    fromHighPct: (current / bars[high].high! - 1) * 100,
  );
}

/// 십자선 상세의 월물 구성: 대표월물은 월물명, 한국형·미국형은 `DEC26 60% · JAN27 40%`.
String? holdingsText(DisparityBar bar, Basis basis) {
  if (bar.holdings.isEmpty) return null;
  if (basis == Basis.front) {
    return formatContractMonth(bar.holdings.first.contractMonth);
  }
  return bar.holdings
      .map((h) {
        final month = formatContractMonth(h.contractMonth);
        return '$month ${(h.weight * 100).round()}%';
      })
      .join(' · ');
}

/// 꼬리 백분위 표시값. 1% 미만은 소수 첫째 자리까지 보여 0%로 뭉개지지 않게 한다.
String formatTailPct(double pct) =>
    pct < 1 ? pct.toStringAsFixed(1) : '${pct.round()}';

/// 이격도 표시(`-18.7%`).
String formatDisparity(double value) => '${formatChange(value, 1)}%';
