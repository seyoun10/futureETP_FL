import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/curve.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/query/keep_alive.dart';

/// 커브 조회 조건. `baseDate`가 null이면 서버 기본값(D-1)이다.
typedef CurveKey = ({CommodityCode code, String? baseDate});

/// C-b 조회(RN `useCurve`). 기준일마다 따로 두고, 화면을 떠나도 1시간 둔다.
/// `nextUpdateAt`까지는 앱 복귀에도 다시 받지 않는다(C 차트 공통).
class CurveNotifier extends AutoRefreshNotifier<Curve> {
  new(this.key);

  final CurveKey key;

  @override
  bool get staleUntilNextUpdate => true;

  @override
  DateTime? nextUpdateAtOf(Curve data) => data.freshness.nextUpdateAt;

  @override
  Future<Curve> fetch() {
    keepAliveFor(ref, chartCacheTime);
    return ref
        .watch(apiClientProvider)
        .getCurve(key.code, baseDate: key.baseDate);
  }
}

final AsyncNotifierProviderFamily<CurveNotifier, Curve, CurveKey>
curveProvider = AsyncNotifierProvider.autoDispose
    .family<CurveNotifier, Curve, CurveKey>(CurveNotifier.new);
