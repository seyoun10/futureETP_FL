/// 휴장 달력 화면의 달·칸 계산(RN `monthGrid.ts`). 날짜는 모두 기기 로컬 기준 `YYYY-MM-DD`다.
library;

typedef CalendarMonth = ({int year, int month});

String _pad(int n) => n.toString().padLeft(2, '0');

String dateKey(int year, int month, int day) =>
    '$year-${_pad(month)}-${_pad(day)}';

/// [at]의 벽시계 날짜.
String localDateKey(DateTime at) => dateKey(at.year, at.month, at.day);

/// [today]가 속한 달부터 [count]개월.
List<CalendarMonth> monthsFrom(DateTime today, int count) => [
  for (var i = 0; i < count; i++)
    (
      year: DateTime.utc(today.year, today.month + i).year,
      month: DateTime.utc(today.year, today.month + i).month,
    ),
];

int _daysInMonth(CalendarMonth m) => DateTime.utc(m.year, m.month + 1, 0).day;

/// 첫 달 1일 ~ 마지막 달 말일.
({String from, String to}) monthsRange(List<CalendarMonth> months) {
  if (months.isEmpty) throw ArgumentError.value(months, 'months', 'empty');
  final first = months.first;
  final last = months.last;
  return (
    from: dateKey(first.year, first.month, 1),
    to: dateKey(last.year, last.month, _daysInMonth(last)),
  );
}

/// 일요일 시작 주 단위 칸. 그 달이 아닌 칸은 null이고, 길이는 7의 배수다.
List<String?> monthCells(CalendarMonth month) {
  final lead = DateTime.utc(month.year, month.month).weekday % 7;
  final cells = <String?>[
    for (var i = 0; i < lead; i++) null,
    for (var day = 1; day <= _daysInMonth(month); day++)
      dateKey(month.year, month.month, day),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return cells;
}

/// `YYYY-MM-DD`의 요일(0 = 일요일).
int weekdayOf(String date) => DateTime.parse('${date}T00:00:00Z').weekday % 7;

/// `YYYY-MM-DD`에 [days]일을 더한다.
String shiftDate(String date, int days) {
  final d = DateTime.parse('${date}T00:00:00Z').add(Duration(days: days));
  return dateKey(d.year, d.month, d.day);
}
