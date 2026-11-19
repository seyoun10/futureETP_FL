// 시각·거래일 표시. 언어와 상관없이 숫자 형식(MM/DD HH:mm)을 쓴다(screens.md 기준 시각 줄).
// RN `apps/mobile/src/lib/formatDateTime.ts`와 같은 결과를 낸다.

String _two(int n) => n.toString().padLeft(2, '0');

/// 시각 → 기기 현지 `MM/DD HH:mm`(24시간, 자정은 00).
/// [utcOffset]을 주면 기기 시간대 대신 그 오프셋으로 쓴다(테스트).
String formatLocalDateTime(DateTime instant, {Duration? utcOffset}) {
  final t = utcOffset == null
      ? instant.toLocal()
      : instant.toUtc().add(utcOffset);
  return '${_two(t.month)}/${_two(t.day)} ${_two(t.hour)}:${_two(t.minute)}';
}

/// CME 거래일 `YYYY-MM-DD` → `MM/DD`. 달력 날짜라 시간대 변환을 하지 않는다.
String formatTradeDate(String tradeDate) =>
    '${tradeDate.substring(5, 7)}/${tradeDate.substring(8, 10)}';
