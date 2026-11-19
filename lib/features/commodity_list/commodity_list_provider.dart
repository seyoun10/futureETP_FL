import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/commodities.dart';
import 'package:futureetp/core/query/auto_refresh.dart';

/// A 원자재 목록 조회(`GET /v1/commodities`). 장중 배치 뒤 자동 새로고침, 앱 복귀 재조회(D-048, D-075).
class CommodityListNotifier extends AutoRefreshNotifier<CommodityList> {
  @override
  Future<CommodityList> fetch() =>
      ref.watch(apiClientProvider).getCommodities();

  @override
  DateTime? nextUpdateAtOf(CommodityList data) => data.freshness.nextUpdateAt;
}

final commodityListProvider =
    AsyncNotifierProvider<CommodityListNotifier, CommodityList>(
      CommodityListNotifier.new,
    );
