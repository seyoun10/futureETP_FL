import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:material_ui/material_ui.dart';

/// 등락 색. 토큰이 아니라 표시 설정에서 고른다(D-031, D-073). 차트·목록이 같은 함수로 읽는다.
@immutable
class UpDownPalette {
  const new({
    required this.up,
    required this.down,
    this.flat = AppColors.neutral,
  });

  final Color up;
  final Color down;

  /// 0·NaN처럼 방향이 없는 값.
  final Color flat;

  /// 한국식: 상승 빨강·하락 파랑.
  static const kr = UpDownPalette(
    up: Color(0xFFEF5350),
    down: Color(0xFF42A5F5),
  );

  /// 미국식: 상승 초록·하락 빨강.
  static const us = UpDownPalette(
    up: Color(0xFF26A69A),
    down: Color(0xFFEF5350),
  );

  /// 스타일마다 같은 const 객체라 비교·캐시 키로 써도 된다.
  static UpDownPalette of(UpDownStyle style) => switch (style) {
    UpDownStyle.kr => kr,
    UpDownStyle.us => us,
  };
}

/// [value]를 [decimals] 자리로 반올림한 값(화면에 쓴 값). JS `Number(x.toFixed(d))`와 같다.
double _shown(double value, int? decimals) =>
    decimals == null ? value : double.parse(value.toStringAsFixed(decimals));

/// 변화량 부호로 색을 고른다. 0·NaN은 방향 없는 색이다.
/// [decimals]를 주면 그 자릿수로 반올림한 값으로 고른다: `0.0%`로 보이는 -0.04는 방향 없는 색.
Color changeColor(double change, UpDownPalette palette, {int? decimals}) {
  final shown = _shown(change, decimals);
  if (shown > 0) return palette.up;
  if (shown < 0) return palette.down;
  return palette.flat;
}

/// 변화량과 등락률을 함께 보이는 줄의 색. 둘 다 반올림해 0이면 방향 없는 색이다.
/// NG처럼 변화량은 `0.000`인데 등락률은 `+0.01%`일 수 있어 둘 중 0이 아닌 쪽을 따른다.
Color changePairColor(
  double change,
  double changePct,
  int decimals,
  UpDownPalette palette,
) {
  final shownChange = _shown(change, decimals);
  final shown = shownChange == 0 || shownChange.isNaN
      ? _shown(changePct, changePctDecimals)
      : shownChange;
  return changeColor(shown, palette);
}

/// 표시 설정의 등락 색. 스타일이 같으면 같은 객체다.
final upDownPaletteProvider = Provider<UpDownPalette>(
  (ref) => UpDownPalette.of(
    ref.watch(displaySettingsProvider.select((s) => s.upDownStyle)),
  ),
);
