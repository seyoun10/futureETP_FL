import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_model.dart';

ContractLine _c(
  String symbol,
  String month,
  String lastTradeDate,
  List<double?> prices, {
  bool isFront = false,
}) => ContractLine(
  symbol: symbol,
  contractMonth: month,
  lastTradeDate: lastTradeDate,
  isFront: isFront,
  prices: prices,
);

ContractsChart _chart(List<ContractLine> contracts) => ContractsChart(
  freshness: Freshness(
    asOf: DateTime.utc(2026, 10, 22, 14, 45),
    tradeDate: '2026-10-22',
    delayed: true,
    marketState: MarketState.open,
    nextUpdateAt: null,
  ),
  priceDecimals: 3,
  dates: const ['2026-10-20', '2026-10-21', '2026-10-22'],
  hasMore: false,
  provisional: true,
  contracts: contracts,
);

final ContractsChart _two = _chart([
  _c('NGZ26', '2026-12', '2026-11-25', [3.1, 3.2, 3.3], isFront: true),
  _c('NGF27', '2027-01', '2026-12-28', [null, 3.5, null]),
]);

void main() {
  final model = ContractModel.from(_two)!;

  test('선마다 만기순 순번 색을 쓰고, 값이 없는 날은 NaN이다', () {
    expect(model.series.lines.map((l) => l.color), [
      ChartColors.contractLines[0],
      ChartColors.contractLines[1],
    ]);
    expect(model.series.lines[1].values[0], isNaN);
  });

  test('날짜마다 값이 있는 선들로 위·아래 끝을 정한다', () {
    expect(model.series.envelopeHigh, [3.1, 3.5, 3.3]);
    expect(model.series.envelopeLow, [3.1, 3.2, 3.3]);
  });

  test('범례는 만기순 선 색과 월물명이고, 대표월물을 표시한다', () {
    expect(model.legend, [
      (label: 'DEC26', color: ChartColors.contractLines[0], isFront: true),
      (label: 'JAN27', color: ChartColors.contractLines[1], isFront: false),
    ]);
  });

  test('끝값 라벨은 보이는 범위에서 각 선의 마지막 값이다', () {
    expect(model.endLabels(0, 2), [
      (price: 3.3, color: ChartColors.contractLines[0]),
      (price: 3.5, color: ChartColors.contractLines[1]),
    ]);
    // 과거로 옮기면 그 범위 끝의 값
    expect(model.endLabels(0, 1).map((l) => l.price), [3.2, 3.5]);
    // 범위 안에 값이 없는 선은 라벨이 없다
    expect(model.endLabels(0, 0).map((l) => l.color), [
      ChartColors.contractLines[0],
    ]);
  });

  test('값이 하나도 없는 선은 끝값·너비용 라벨이 없다', () {
    final empty = ContractModel.from(
      _chart([
        _c('NGZ26', '2026-12', '2026-11-25', [null, null, null]),
      ]),
    )!;
    expect(empty.endLabels(0, 2), isEmpty);
    expect(empty.widestLabels, isEmpty);
  });

  test('날짜나 월물이 없으면 모델이 없다', () {
    expect(ContractModel.from(_chart(const [])), isNull);
    expect(
      ContractModel.from(_two.copyWith(dates: const [], contracts: const [])),
      isNull,
    );
  });

  test('너비용 라벨은 선마다 글자가 가장 긴 값이다(음수 포함)', () {
    final wide = ContractModel.from(
      _chart([
        _c('CLK20', '2020-05', '2020-04-21', [18.27, -37.63, 10.01]),
      ]),
    )!;
    expect(wide.widestLabels, [-37.63]);
    expect(wide.series.logScale, isFalse);
    expect(model.widestLabels, [3.3, 3.5]);
  });

  test('6번째 이후 선은 마지막 색을 같이 쓴다', () {
    final many = ContractModel.from(
      _chart([
        for (var i = 0; i < 7; i++)
          _c('S$i', '2027-01', '2026-12-28', [1, 1, 1]),
      ]),
    )!;
    expect(many.series.lines[6].color, ChartColors.contractLines[5]);
  });

  test('롤 수익률은 그날 양끝 월물의 연환산 (near / far − 1) × 365 / 만기 간격이다', () {
    final data = _chart([
      _c('NGZ26', '2026-12', '2026-11-25', [3.3, 3.3, 3.3], isFront: true),
      _c('NGF27', '2027-01', '2026-12-28', [null, 3.0, null]),
      _c('NGG27', '2027-02', '2027-01-27', [null, 3.0, 3.0]),
    ]);
    // 값이 하나뿐이면 없다
    expect(endsRollYieldPct(data, 0), isNull);
    // 가장 먼 값은 NGG27(63일)
    expect(endsRollYieldPct(data, 1), closeTo(0.1 * 365 * 100 / 63, 1e-9));
    // 가운데 월물이 비어도 양끝으로 센다
    expect(endsRollYieldPct(data, 2), closeTo(0.1 * 365 * 100 / 63, 1e-9));
  });

  test('롤 수익률은 값이 0 이하이거나 만기가 같으면 없다', () {
    final data = _chart([
      _c('A', '2026-12', '2026-11-25', [-1, 3, 3], isFront: true),
      _c('B', '2027-01', '2026-12-28', [3, null, null]),
      _c('C', '2027-01', '2026-11-25', [null, null, 3]),
    ]);
    expect(endsRollYieldPct(data, 0), isNull);
    expect(endsRollYieldPct(data, 2), isNull);
  });
}
