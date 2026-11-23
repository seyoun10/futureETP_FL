import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/calendar.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/query/keep_alive.dart';
import 'package:futureetp/features/calendar/local_schedule.dart';
import 'package:material_ui/material_ui.dart';

/// 달력 조회 범위. `YYYY-MM-DD`(포함).
typedef CalendarRange = ({String from, String to});

/// 휴장 일정은 연 몇 번만 바뀌므로 오래 둔다(RN `useMarketCalendar` `STALE_MS`).
const calendarStaleTime = Duration(hours: 12);

/// 입력되지 않은 (시장, 연도)가 있으면 곧 import될 수 있으니 짧게 둔다(RN `MISSING_STALE_MS`).
/// 빈 달력을 12시간 붙잡으면 서버에 import한 뒤에도 앱을 다시 켜야 보인다.
const calendarMissingStaleTime = Duration(minutes: 5);

/// 화면을 떠난 뒤 둘 시간(RN react-query 기본 `gcTime`).
const calendarCacheTime = Duration(minutes: 5);

/// [data]를 새 값으로 볼 시간.
Duration calendarStaleTimeOf(MarketCalendar data) =>
    data.missing.isEmpty ? calendarStaleTime : calendarMissingStaleTime;

/// A-a 휴장 달력 조회(`GET /v1/calendar`, D-143, RN `useMarketCalendar`).
///
/// 범위마다 따로 두고, 화면을 떠나도 [calendarCacheTime] 동안 둔다. 화면에 다시 들어오거나
/// 앱이 앞으로 돌아왔을 때 [calendarStaleTimeOf]가 지났으면 다시 조회한다.
class CalendarNotifier extends AsyncNotifier<MarketCalendar> {
  new(this.range);

  final CalendarRange range;

  @override
  Future<MarketCalendar> build() async {
    keepAliveFor(ref, calendarCacheTime);
    final data = await ref
        .watch(apiClientProvider)
        .getCalendar(range.from, range.to);
    if (!ref.mounted) return data;
    final staleAt = clock.now().add(calendarStaleTimeOf(data));
    // 생명주기 콜백 안에서는 Ref를 쓸 수 없어 마이크로태스크로 미룬다
    void refetchIfStale() {
      if (!clock.now().isBefore(staleAt)) {
        scheduleMicrotask(() {
          if (ref.mounted) ref.invalidateSelf();
        });
      }
    }

    ref
      ..onResume(refetchIfStale)
      ..listen(appLifecycleProvider, (_, next) {
        if (next == AppLifecycleState.resumed) refetchIfStale();
      });
    return data;
  }
}

final AsyncNotifierProviderFamily<
  CalendarNotifier,
  MarketCalendar,
  CalendarRange
>
calendarProvider = AsyncNotifierProvider.autoDispose
    .family<CalendarNotifier, MarketCalendar, CalendarRange>(
      CalendarNotifier.new,
    );

/// UTC → 기기 벽시계 변환(FL-037). 위젯 테스트는 시간대를 고정한다.
final calendarToLocalProvider = Provider<ToLocal>((ref) => deviceLocal);
