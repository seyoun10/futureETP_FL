import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/query/keep_alive.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:material_ui/material_ui.dart';

/// C-a 조회 결과와 그 조건. 조건이 같을 때만 받아 둔 과거 봉을 이어 쓴다.
@immutable
class DisparityData {
  const new(this.params, this.chart);

  final DisparityParams params;

  /// 최근 3년 응답에 이전에 받은 과거 봉을 앞에 붙인 것.
  final DisparityChart chart;
}

DisparityParams disparityParamsOf(DeviceSettings s) => DisparityParams(
  basis: s.basis,
  ma: s.maPeriod,
  window: s.window,
  levels: s.rareLevels,
);

/// C-a 조회(RN `useDisparityChart`).
///
/// - 기기 설정(기준값·이평선·윈도·rare 레벨)을 먼저 읽고 그 값으로 최근 3년을 받는다(D-086, D-104).
///   설정의 그 값이 바뀔 때만 다시 받는다.
/// - [loadOlder]는 가장 이른 봉보다 이전 3년을 받아 앞에 붙인다.
/// - 자동 새로고침·앱 복귀 재조회는 최근 3년만 다시 받고, 조건이 같으면 받아 둔 과거 봉을 이어 붙인다.
///   `nextUpdateAt`까지는 앱 복귀에도 다시 받지 않는다(RN `staleUntilNextUpdate`).
class DisparityChartNotifier extends AutoRefreshNotifier<DisparityData> {
  new(this.code);

  final CommodityCode code;

  @override
  bool get staleUntilNextUpdate => true;

  @override
  DateTime? nextUpdateAtOf(DisparityData data) =>
      data.chart.freshness.nextUpdateAt;

  @override
  Future<DisparityData> fetch() async {
    keepAliveFor(ref, chartCacheTime);
    final params = await ref.watch(
      deviceSettingsProvider.selectAsync(disparityParamsOf),
    );
    final latest = await ref
        .watch(apiClientProvider)
        .getDisparityChart(code, params);
    final previous = state.value;
    if (previous == null || previous.params != params) {
      return DisparityData(params, latest);
    }
    return DisparityData(params, _keepOlder(previous.chart, latest));
  }

  /// 이전 3년을 앞에 붙인다. 더 받을 것이 없으면 아무것도 하지 않는다. 실패는 그대로 던진다.
  /// 받는 사이 조건이 바뀌거나 다른 받기가 먼저 붙였으면 버린다.
  Future<void> loadOlder() async {
    final current = state.value;
    if (current == null ||
        !current.chart.hasMore ||
        current.chart.bars.isEmpty) {
      return;
    }
    final first = current.chart.bars.first.tradeDate;
    final older = await ref
        .read(apiClientProvider)
        .getDisparityChart(code, current.params, before: first);
    final now = state.value;
    if (!ref.mounted ||
        now == null ||
        now.params != current.params ||
        now.chart.bars.firstOrNull?.tradeDate != first) {
      return;
    }
    state = AsyncData(
      DisparityData(
        now.params,
        now.chart.copyWith(
          bars: [...older.bars, ...now.chart.bars],
          hasMore: older.hasMore,
        ),
      ),
    );
  }

  /// 최근 응답 앞에 [previous]의 더 이른 봉을 붙인다.
  static DisparityChart _keepOlder(
    DisparityChart previous,
    DisparityChart latest,
  ) {
    final start = latest.bars.firstOrNull?.tradeDate;
    if (start == null) return latest;
    final older = [
      for (final bar in previous.bars)
        if (bar.tradeDate.compareTo(start) < 0) bar,
    ];
    if (older.isEmpty) return latest;
    return latest.copyWith(
      bars: [...older, ...latest.bars],
      hasMore: previous.hasMore,
    );
  }
}

final AsyncNotifierProviderFamily<
  DisparityChartNotifier,
  DisparityData,
  CommodityCode
>
disparityChartProvider = AsyncNotifierProvider.autoDispose
    .family<DisparityChartNotifier, DisparityData, CommodityCode>(
      DisparityChartNotifier.new,
    );
