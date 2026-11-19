import 'package:futureetp/core/util/format_number.dart';

// 순자산·거래대금 같은 큰 금액을 단위로 줄인다(screens.md C-d 예: `1,234억 원`, `$12.3M`).
// 통화 표기는 i18n 문구가 붙인다. 단위는 월물 표기처럼 숫자 표기로 보고 여기 둔다.
// RN `apps/mobile/src/lib/formatAmount.ts`와 같은 결과를 낸다.

enum AmountScheme {
  /// 억·만은 정수(1,234억), 그 아래는 원 단위.
  eok(0, [('억', 1e8), ('만', 1e4)]),

  /// T·B·M·K는 소수 한 자리(12.3M).
  si(1, [('T', 1e12), ('B', 1e9), ('M', 1e6), ('K', 1e3)]);

  new(this.decimals, this.units);

  final int decimals;

  /// 큰 단위부터.
  final List<(String, double)> units;
}

String compactAmount(double value, AmountScheme scheme) {
  final AmountScheme(:decimals, :units) = scheme;
  final index = units.indexWhere((u) => value.abs() >= u.$2);
  if (index == -1) return formatPrice(value, 0);
  final (unit, size) = units[index];
  // 반올림해서 위 단위에 닿으면(9,999.6만 → 10,000만) 위 단위로 쓴다(1억)
  if (index > 0) {
    final (upperUnit, upperSize) = units[index - 1];
    final rounded = double.parse((value / size).toStringAsFixed(decimals))
        .abs();
    if (rounded >= upperSize / size) {
      return '${formatPrice(value / upperSize, decimals)}$upperUnit';
    }
  }
  return '${formatPrice(value / size, decimals)}$unit';
}
