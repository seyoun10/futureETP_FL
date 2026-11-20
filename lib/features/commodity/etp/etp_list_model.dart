import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/etp.dart';

// C-d 필터·정렬(RN `features/commodity/etp/etpListModel.ts`·`lib/etpSort.ts`).
// 받은 목록 안에서 하고 선택은 기억하지 않는다(D-017).

/// C-d 정렬 기준.
enum EtpSort { byDefault, aum, tradingValue }

/// C-d 필터. null은 `전체`(거르지 않음)다.
typedef EtpFilters = ({
  EtpMarket? market,
  EtpType? type,
  double? leverage,
  FxHedge? fxHedge,
});

const EtpFilters noEtpFilters = (
  market: null,
  type: null,
  leverage: null,
  fxHedge: null,
);

List<EtpSummary> filterEtps(List<EtpSummary> etps, EtpFilters filters) => [
  for (final etp in etps)
    if ((filters.market == null || etp.market == filters.market) &&
        (filters.type == null || etp.type == filters.type) &&
        (filters.leverage == null || etp.leverage == filters.leverage) &&
        (filters.fxHedge == null || etp.fxHedge == filters.fxHedge))
      etp,
];

/// 배수 순서: 양수 먼저, 각각 절댓값 오름차순(1, 2, -1, -2).
int compareLeverage(double a, double b) {
  final sign = (a < 0 ? 1 : 0) - (b < 0 ? 1 : 0);
  return sign != 0 ? sign : a.abs().compareTo(b.abs());
}

int _byMarket(EtpSummary a, EtpSummary b) =>
    a.market.index.compareTo(b.market.index);

/// 이름순. RN `localeCompare`처럼 대소문자를 먼저 무시한다.
int _byName(EtpSummary a, EtpSummary b) {
  final folded = a.name.toLowerCase().compareTo(b.name.toLowerCase());
  return folded != 0 ? folded : a.name.compareTo(b.name);
}

/// 기본: 시장(KRX → US), 배수, 이름순(screens.md C-d).
int _byDefault(EtpSummary a, EtpSummary b) {
  final market = _byMarket(a, b);
  if (market != 0) return market;
  final leverage = compareLeverage(a.leverage, b.leverage);
  return leverage != 0 ? leverage : _byName(a, b);
}

/// 큰 순서이고 값이 없으면 뒤로.
int _byValueDesc(double? a, double? b) => switch ((a, b)) {
  (null, null) => 0,
  (null, _) => 1,
  (_, null) => -1,
  (final a?, final b?) => b.compareTo(a),
};

/// 정렬 값(행 둘째 줄 끝에 붙임). 기본 정렬이면 붙이지 않는다(`hasValue` false).
({bool hasValue, double? value}) sortValue(EtpSummary etp, EtpSort sort) =>
    switch (sort) {
      EtpSort.byDefault => (hasValue: false, value: null),
      EtpSort.aum => (hasValue: true, value: etp.aum),
      EtpSort.tradingValue => (hasValue: true, value: etp.avgTradingValue),
    };

/// 순자산·거래대금은 통화가 달라 시장 안에서만 정렬한다(D-017).
List<EtpSummary> sortEtps(List<EtpSummary> etps, EtpSort sort) {
  final sorted = [...etps];
  if (sort == EtpSort.byDefault) return sorted..sort(_byDefault);
  return sorted..sort((a, b) {
    final market = _byMarket(a, b);
    if (market != 0) return market;
    final value = _byValueDesc(
      sortValue(a, sort).value,
      sortValue(b, sort).value,
    );
    return value != 0 ? value : _byDefault(a, b);
  });
}

/// 배수 필터 선택지: 받은 상품에 있는 배수만.
List<double> leverageOptions(List<EtpSummary> etps) =>
    {for (final etp in etps) etp.leverage}.toList()..sort(compareLeverage);

/// 배수·총보수 숫자 표기. 정수면 소수점을 붙이지 않는다(`2`, `-1`, `1.5`, RN 숫자 문자열과 같음).
String plainNumber(double value) => value == value.truncateToDouble()
    ? value.toInt().toString()
    : value.toString();
