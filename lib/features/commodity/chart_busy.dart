import 'package:flutter_riverpod/flutter_riverpod.dart';

/// C 화면에서 차트가 이전 3년을 받는 동안 title-bar·tab-bar·기간 칩까지 터치를 막는다(D-139).
/// 차트 안 제스처는 차트의 `locked`가 따로 멈춘다(D-108). C를 떠나면 잊는다.
class ChartBusyNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  // ignore: use_setters_to_change_properties 읽는 쪽은 Provider를 본다
  void set({required bool busy}) => state = busy;
}

final NotifierProvider<ChartBusyNotifier, bool> chartBusyProvider =
    NotifierProvider.autoDispose<ChartBusyNotifier, bool>(
      ChartBusyNotifier.new,
    );
