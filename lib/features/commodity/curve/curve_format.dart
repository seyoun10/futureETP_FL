import 'package:futureetp/core/util/format_number.dart';
import 'package:intl/intl.dart';

// C-b 날짜·변화율 표기(RN `curveModel.ts`).

/// 기준일 버튼. 멀리 옮길 수 있어 연도를 항상 쓴다(`2026/10/21`, D-115).
String formatFullDate(String date) => date.replaceAll('-', '/');

/// 범례·상세 날짜: [currentDate](D)와 같은 해면 `MM/DD`, 아니면 `YYYY/MM/DD`(D-116).
String formatLegendDate(String date, String currentDate) =>
    date.substring(0, 4) == currentDate.substring(0, 4)
    ? formatFullDate(date).substring(5)
    : formatFullDate(date);

/// 휴장일 안내의 요일(`금`, `Fri`). 날짜만이라 UTC로 센다.
String formatWeekday(String date, String locale) =>
    DateFormat.E(locale).format(DateTime.parse('${date}T00:00:00Z'));

/// 커브 변화율 소수 자릿수. 점이 많아 첫째 자리까지.
const curvePctDecimals = 1;

/// 커브 변화율 `+0.5%`.
String formatCurvePct(double pct) => '${formatChange(pct, curvePctDecimals)}%';

/// 날짜 `YYYY-MM-DD` ↔ 기기 시간대 자정 `DateTime`(날짜 선택기).
DateTime toPickerDate(String date) {
  final [y, m, d] = date.split('-').map(int.parse).toList();
  return DateTime(y, m, d);
}

String fromPickerDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
