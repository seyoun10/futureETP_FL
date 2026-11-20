import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/etp.dart';
import 'package:futureetp/core/query/auto_refresh.dart';
import 'package:futureetp/core/query/keep_alive.dart';

/// 화면을 떠난 조회를 두는 시간(RN react-query 기본 `gcTime`).
const etpCacheTime = Duration(minutes: 5);

/// C-d 조회(RN `useEtps`). 하루 1회 수집이라 자동 새로고침은 없고 앱 복귀 때만 다시 받는다
/// (screens.md 공통 규칙, D-030).
class EtpListNotifier extends AutoRefreshNotifier<EtpList> {
  new(this.code);

  final CommodityCode code;

  @override
  DateTime? nextUpdateAtOf(EtpList data) => null;

  @override
  Future<EtpList> fetch() {
    keepAliveFor(ref, etpCacheTime);
    return ref.watch(apiClientProvider).getEtps(code);
  }
}

final AsyncNotifierProviderFamily<EtpListNotifier, EtpList, CommodityCode>
etpListProvider = AsyncNotifierProvider.autoDispose
    .family<EtpListNotifier, EtpList, CommodityCode>(EtpListNotifier.new);

/// C-d-a 조회(RN `useEtp`). 목록과 같이 앱 복귀 때만 다시 받는다.
class EtpDetailNotifier extends AutoRefreshNotifier<EtpDetail> {
  new(this.id);

  final String id;

  @override
  DateTime? nextUpdateAtOf(EtpDetail data) => null;

  @override
  Future<EtpDetail> fetch() {
    keepAliveFor(ref, etpCacheTime);
    return ref.watch(apiClientProvider).getEtp(id);
  }
}

final AsyncNotifierProviderFamily<EtpDetailNotifier, EtpDetail, String>
etpDetailProvider = AsyncNotifierProvider.autoDispose
    .family<EtpDetailNotifier, EtpDetail, String>(EtpDetailNotifier.new);
