// 시세 숫자 표시. 언어와 상관없이 `2,405.1`·`+12.2`·`-1.04%` 형식이다(screens.md A).
// RN `apps/mobile/src/lib/formatNumber.ts`와 같은 결과를 낸다. intl NumberFormat은 locale을 타서 쓰지 않는다.

final _thousands = RegExp(r'\B(?=(\d{3})+(?!\d))');
final _allZero = RegExp(r'^0*$');
final _zeroLike = RegExp(r'^[0.,]+$');

/// 천 단위 쉼표 + 고정 소수 자릿수. 반올림해 0이면 `-`를 붙이지 않는다.
String formatPrice(double value, int decimals) {
  final fixed = value.abs().toStringAsFixed(decimals);
  final dot = fixed.indexOf('.');
  final integer = dot == -1 ? fixed : fixed.substring(0, dot);
  final fraction = dot == -1 ? null : fixed.substring(dot + 1);
  final grouped = integer.replaceAll(_thousands, ',');
  final sign = value < 0 && !_allZero.hasMatch(integer + (fraction ?? ''))
      ? '-'
      : '';
  return '$sign$grouped${fraction == null ? '' : '.$fraction'}';
}

/// 부호 붙인 변화량. 반올림해서 0이면 부호를 붙이지 않는다.
String formatChange(double value, int decimals) {
  final abs = formatPrice(value.abs(), decimals);
  if (_zeroLike.hasMatch(abs)) return abs;
  return '${value < 0 ? '-' : '+'}$abs';
}

/// 등락률(%) 소수 자릿수.
const changePctDecimals = 2;

/// 등락률 `+0.51%`.
String formatChangePct(double pct) =>
    '${formatChange(pct, changePctDecimals)}%';

const _months = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', //
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

/// 월물 `YYYY-MM` → `DEC26`(CME 월물 표기라 언어와 상관없다).
String formatContractMonth(String contractMonth) =>
    '${_months[int.parse(contractMonth.substring(5, 7)) - 1]}'
    '${contractMonth.substring(2, 4)}';

/// 월물 `YYYY-MM` → `2612`(C-b x축은 월물이 많아 숫자로 줄인다).
String formatContractMonthShort(String contractMonth) =>
    '${contractMonth.substring(2, 4)}${contractMonth.substring(5, 7)}';
