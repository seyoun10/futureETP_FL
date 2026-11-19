import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

/// 1초마다 그린 프레임 수와 가장 느린 프레임(build+raster) 시간.
typedef FrameStat = ({int fps, double worstMs});

/// 엔진 `FrameTiming`으로 프레임을 센다. 정지 중엔 프레임이 없어 0fps다.
class FrameStats extends ValueNotifier<FrameStat> {
  new() : super((fps: 0, worstMs: 0)) {
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      value = (fps: _frames, worstMs: _worst);
      _frames = 0;
      _worst = 0;
    });
  }

  late final Timer _timer;
  var _frames = 0;
  var _worst = 0.0;

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      _frames++;
      _worst = math.max(_worst, t.totalSpan.inMicroseconds / 1000);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    super.dispose();
  }
}
