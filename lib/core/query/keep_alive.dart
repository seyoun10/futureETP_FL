import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// C 차트 응답은 크고 첫 조회·그리기가 느리다. 화면을 떠나도 1시간은 둔다(RN `CHART_GC_TIME_MS`).
const chartCacheTime = Duration(hours: 1);

/// 듣는 화면이 없어져도 [duration] 동안 Provider를 둔다(RN `gcTime`). 조회(`build`) 안에서 부른다.
void keepAliveFor(Ref ref, Duration duration) {
  final link = ref.keepAlive();
  Timer? timer;
  ref
    ..onCancel(() => timer = Timer(duration, link.close))
    ..onResume(() => timer?.cancel())
    ..onDispose(() => timer?.cancel());
}
