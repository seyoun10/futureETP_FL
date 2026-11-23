import 'package:material_ui/material_ui.dart';

/// RN `Icon`(`@expo/vector-icons` MaterialCommunityIcons)과 같은 글리프(FL-038).
/// 코드포인트는 `@expo/vector-icons` 15.1.1 `glyphmaps/MaterialCommunityIcons.json` 값이다.
abstract final class MdiIcons {
  static const _family = 'MaterialCommunityIcons';

  /// `arrow-left`: 화면 헤더 [←].
  static const arrowLeft = IconData(0xf004d, fontFamily: _family);

  /// `cog-outline`: 설정 [⚙].
  static const cogOutline = IconData(0xf08bb, fontFamily: _family);

  /// `calendar-month-outline`: A-a 휴장 달력 [📅].
  static const calendarMonthOutline = IconData(0xf0e18, fontFamily: _family);

  /// `restore`: B 기본값 되돌리기, 차트 보기 되돌리기.
  static const restore = IconData(0xf099b, fontFamily: _family);

  /// `chevron-left`.
  static const chevronLeft = IconData(0xf0141, fontFamily: _family);

  /// `chevron-right`.
  static const chevronRight = IconData(0xf0142, fontFamily: _family);

  /// `phone-rotate-landscape`: 세로에서 가로로 돌리기.
  static const phoneRotateLandscape = IconData(0xf0885, fontFamily: _family);

  /// `phone-rotate-portrait`: 가로에서 세로로 돌리기.
  static const phoneRotatePortrait = IconData(0xf0886, fontFamily: _family);
}
