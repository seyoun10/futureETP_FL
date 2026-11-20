import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/commodities.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/settings/device_settings.dart';

/// A 원자재 목록 조회(`GET /v1/commodities`). 장중 배치 뒤 자동 새로고침, 앱 복귀 재조회(D-048, D-075).
/// 서버가 확인한 알림 대상이 바뀌면 다시 받는다. B는 A 위에 쌓여 A가 다시 만들어지지 않으므로,
/// 그러지 않으면 🔔가 다음 새로고침까지 옛 값으로 남아 [⚙] 점과 어긋난다(D-124).
class CommodityListNotifier extends AutoRefreshNotifier<CommodityList> {
  @override
  Future<CommodityList> fetch() {
    ref.listen(deviceSettingsProvider, (prev, next) {
      if ((prev?.value, next.value) case (final p?, final n?)
          when p.alertCommodity != n.alertCommodity) {
        ref.invalidateSelf();
      }
    });
    return ref.watch(apiClientProvider).getCommodities();
  }

  @override
  DateTime? nextUpdateAtOf(CommodityList data) => data.freshness.nextUpdateAt;
}

final commodityListProvider =
    AsyncNotifierProvider<CommodityListNotifier, CommodityList>(
      CommodityListNotifier.new,
    );
