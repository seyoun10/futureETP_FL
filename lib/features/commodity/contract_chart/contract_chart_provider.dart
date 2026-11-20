import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/query/keep_alive.dart';

/// C-c 조회(RN `useContracts`).
///
/// - 최근 3년을 받는다(D-104). 기기 설정과 상관없다.
/// - [loadOlder]는 가장 이른 날짜보다 이전 3년을 받아 앞에 붙인다.
/// - 자동 새로고침·앱 복귀 재조회는 최근 3년만 다시 받고, 받아 둔 과거 날짜를 이어 붙인다.
///   `nextUpdateAt`까지는 앱 복귀에도 다시 받지 않는다(RN `staleUntilNextUpdate`).
class ContractChartNotifier extends AutoRefreshNotifier<ContractsChart> {
  new(this.code);

  final CommodityCode code;

  @override
  bool get staleUntilNextUpdate => true;

  @override
  DateTime? nextUpdateAtOf(ContractsChart data) => data.freshness.nextUpdateAt;

  @override
  Future<ContractsChart> fetch() async {
    keepAliveFor(ref, chartCacheTime);
    final latest = await ref.watch(apiClientProvider).getContracts(code);
    final previous = state.value;
    if (previous == null) return latest;
    final start = latest.dates.firstOrNull;
    if (start == null) return latest;
    final keep = previous.dates.indexWhere((d) => d.compareTo(start) >= 0);
    final count = keep < 0 ? previous.dates.length : keep;
    if (count == 0) return latest;
    return prependContracts(
      _head(previous, count),
      latest,
      hasMore: previous.hasMore,
    );
  }

  /// 이전 3년을 앞에 붙인다. 더 받을 것이 없으면 아무것도 하지 않는다. 실패는 그대로 던진다.
  /// 받는 사이 다른 받기·새로고침이 앞을 바꿨으면 버린다.
  Future<void> loadOlder() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.dates.isEmpty) return;
    final first = current.dates.first;
    final older = await ref
        .read(apiClientProvider)
        .getContracts(code, before: first);
    final now = state.value;
    if (!ref.mounted || now == null || now.dates.firstOrNull != first) return;
    state = AsyncData(prependContracts(older, now, hasMore: older.hasMore));
  }

  /// 앞 [count]개 날짜만 남긴 것.
  static ContractsChart _head(ContractsChart chart, int count) =>
      chart.copyWith(
        dates: chart.dates.sublist(0, count),
        contracts: [
          for (final c in chart.contracts)
            c.copyWith(prices: c.prices.sublist(0, count)),
        ],
      );
}

/// [newer] 앞에 [older]의 날짜·가격을 붙인다(RN `mergeContractPages`).
/// 월물 목록은 [newer]를 따르고, [older]에 없는 월물은 그 구간을 null로 채운다.
/// [older]에만 있는 월물은 버린다.
ContractsChart prependContracts(
  ContractsChart older,
  ContractsChart newer, {
  required bool hasMore,
}) {
  final bySymbol = {for (final c in older.contracts) c.symbol: c};
  final gap = List<double?>.filled(older.dates.length, null);
  return newer.copyWith(
    dates: [...older.dates, ...newer.dates],
    hasMore: hasMore,
    contracts: [
      for (final c in newer.contracts)
        c.copyWith(prices: [...bySymbol[c.symbol]?.prices ?? gap, ...c.prices]),
    ],
  );
}

final AsyncNotifierProviderFamily<
  ContractChartNotifier,
  ContractsChart,
  CommodityCode
>
contractChartProvider = AsyncNotifierProvider.autoDispose
    .family<ContractChartNotifier, ContractsChart, CommodityCode>(
      ContractChartNotifier.new,
    );
