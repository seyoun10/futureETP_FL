import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/models/calendar.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/features/calendar/calendar_provider.dart';
import 'package:futureetp/features/calendar/local_schedule.dart';
import 'package:futureetp/features/calendar/month_grid.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

const _monthCount = 3;

/// `calendarWeekday` select 키. 0 = 일요일.
const _weekdayKeys = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];

const _dot = 6.0;
const _daySize = 30.0;

Color marketColor(CalendarMarket market) => switch (market) {
  CalendarMarket.cme => MarketColors.cme,
  CalendarMarket.krx => MarketColors.krx,
  CalendarMarket.nyse => MarketColors.nyse,
};

String _marketWire(CalendarMarket market) => market.name.toUpperCase();

String _kindText(AppLocalizations l10n, LocalCalendarException e) =>
    l10n.calendarKind(switch (e.kind) {
      CalendarExceptionKind.closed => 'CLOSED',
      CalendarExceptionKind.halt => 'HALT',
      CalendarExceptionKind.earlyClose => 'EARLY_CLOSE',
      CalendarExceptionKind.lateOpen => 'LATE_OPEN',
    }, e.localTime ?? '');

bool _isWeekend(int weekday) => weekday == 0 || weekday == 6;

/// A-a 휴장 달력(screens.md A-a, D-143, D-144, RN `CalendarScreen`).
///
/// 이번 달~다다음 달을 세로로 놓고 CME·KRX·NYSE 예외 일정을 함께 표시한다. 오늘·일정 모두
/// 기기 로컬 날짜·시각이다. 화면을 여는 동안 날짜가 바뀌어도 다시 열 때까지 그대로 둔다.
class CalendarScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final DateTime _today = clock.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final months = monthsFrom(_today, _monthCount);
    final range = monthsRange(months);
    // 로컬로 옮기면 시장 날짜가 하루 앞뒤로 움직이므로 하루씩 넓혀 받는다
    final provider = calendarProvider(widenRange(range));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScreenHeader(title: l10n.calendarTitle),
          Expanded(
            child: QueryStateView(
              value: ref.watch(provider),
              onRetry: () => ref.invalidate(provider),
              builder: (context, data) => _CalendarBody(
                data: data,
                months: months,
                firstYear: int.parse(range.from.substring(0, 4)),
                lastYear: int.parse(range.to.substring(0, 4)),
                todayKey: localDateKey(_today),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarBody extends ConsumerWidget {
  const new({
    required this.data,
    required this.months,
    required this.firstYear,
    required this.lastYear,
    required this.todayKey,
  });

  final MarketCalendar data;
  final List<CalendarMonth> months;
  final int firstYear;
  final int lastYear;
  final String todayKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final byDate = <String, List<LocalCalendarException>>{};
    for (final e in toLocalExceptions(
      data.exceptions,
      toLocal: ref.watch(calendarToLocalProvider),
    )) {
      (byDate[e.localDate] ??= []).add(e);
    }
    // 넓혀 받은 하루 때문에 화면 밖 연도의 미입력 안내가 섞이지 않게 거른다
    final missing = data.missing.where(
      (m) => m.year >= firstYear && m.year <= lastYear,
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        const _Legend(),
        for (final m in missing)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              l10n.calendarMissing(
                l10n.calendarMarket(_marketWire(m.market)),
                '${m.year}',
              ),
              style: const TextStyle(
                color: AppColors.error,
                fontSize: AppFontSize.caption,
              ),
            ),
          ),
        for (final month in months)
          _MonthView(month: month, byDate: byDate, todayKey: todayKey),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget item(Widget mark, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        mark,
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppFontSize.caption,
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.xs,
        children: [
          for (final market in CalendarMarket.values)
            item(
              _Dot(color: marketColor(market), filled: true),
              l10n.calendarMarket(_marketWire(market)),
            ),
          item(
            const _Dot(color: AppColors.textSecondary, filled: true),
            l10n.calendarLegendClosed,
          ),
          item(
            const _Dot(color: AppColors.textSecondary, filled: false),
            l10n.calendarLegendShortened,
          ),
          item(
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.today),
              ),
            ),
            l10n.calendarLegendToday,
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const new({required this.color, required this.filled});

  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) => Container(
    width: _dot,
    height: _dot,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: filled ? color : null,
      border: filled ? null : Border.all(color: color),
    ),
  );
}

class _MonthView extends StatelessWidget {
  const new({
    required this.month,
    required this.byDate,
    required this.todayKey,
  });

  final CalendarMonth month;
  final Map<String, List<LocalCalendarException>> byDate;
  final String todayKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cells = monthCells(month);
    final monthName = l10n.calendarMonthName('${month.month}');
    final items = [for (final date in cells.nonNulls) ...?byDate[date]];
    return Container(
      key: ValueKey('calendar-month-${month.year}-${month.month}'),
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.separator)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Semantics(
              header: true,
              child: Text(
                l10n.calendarMonthTitle('${month.year}', monthName),
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: AppFontSize.title,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final (weekday, key) in _weekdayKeys.indexed)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      l10n.calendarWeekday(key),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isWeekend(weekday)
                            ? AppColors.textSecondary
                            : AppColors.text,
                        fontSize: AppFontSize.caption,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          for (var i = 0; i < cells.length; i += 7)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final date in cells.sublist(i, i + 7))
                  Expanded(
                    child: date == null
                        ? const SizedBox(height: 48)
                        : _DayCell(
                            date: date,
                            monthName: monthName,
                            exceptions: byDate[date] ?? const [],
                            isToday: date == todayKey,
                          ),
                  ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.xs,
              children: items.isEmpty
                  ? [
                      Text(
                        l10n.calendarNone,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppFontSize.caption,
                        ),
                      ),
                    ]
                  : [for (final e in items) _ExceptionLine(e)],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const new({
    required this.date,
    required this.monthName,
    required this.exceptions,
    required this.isToday,
  });

  final String date;
  final String monthName;
  final List<LocalCalendarException> exceptions;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = int.parse(date.substring(8, 10));
    final label = [
      l10n.calendarCellDate(monthName, '$day'),
      if (isToday) l10n.calendarLegendToday,
      for (final e in exceptions)
        '${l10n.calendarMarket(_marketWire(e.market))} ${_kindText(l10n, e)}',
    ].join(', ');
    return Semantics(
      key: ValueKey('calendar-day-$date'),
      container: true,
      label: label,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              Container(
                width: _daySize,
                height: _daySize,
                alignment: Alignment.center,
                decoration: isToday
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.today, width: 1.5),
                      )
                    : null,
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: _isWeekend(weekdayOf(date))
                        ? AppColors.textSecondary
                        : AppColors.text,
                    fontSize: AppFontSize.body,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Container(
                height: _dot + 2,
                margin: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  children: [
                    for (final e in exceptions)
                      _Dot(color: marketColor(e.market), filled: e.isClosed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExceptionLine extends StatelessWidget {
  const new(this.e);

  final LocalCalendarException e;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = marketColor(e.market);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        SizedBox(
          width: 64,
          child: Text(
            l10n.calendarListDate(
              formatTradeDate(e.localDate),
              l10n.calendarWeekday(_weekdayKeys[weekdayOf(e.localDate)]),
            ),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: AppFontSize.caption,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            l10n.calendarMarket(_marketWire(e.market)),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: _kindText(l10n, e),
              children: [
                TextSpan(
                  text: ' · ${e.exception.note}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: AppFontSize.caption,
            ),
          ),
        ),
      ],
    );
  }
}
