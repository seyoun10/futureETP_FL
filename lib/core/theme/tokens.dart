import 'package:material_ui/material_ui.dart';

// 테마 토큰(D-031, D-073). 값은 RN `apps/mobile/src/theme/tokens.ts`와 같다.
// 다크 전용이라 테마 전환은 없다. 화면·차트는 숫자·색을 직접 쓰지 않고 여기서 읽는다.

/// 색.
abstract final class AppColors {
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF1E1E1E);
  static const surfaceSelected = Color(0xFF3A3A6A);
  static const border = Color(0xFF2A2A2A);

  /// 목록 항목 사이 구분선. [border]보다 밝다.
  static const separator = Color(0xFF4A4A4A);

  /// title-bar 아래·tab-bar 위 구분선.
  static const barSeparator = Color(0xFFFFFFFF);

  /// 차트 위에 겹친 정보 줄 배경(뒤의 rare-level 선·격자가 비쳐 보이게).
  static const overlay = Color.fromRGBO(0, 0, 0, 0.65);
  static const text = Color(0xFFE0E0E0);
  static const textSecondary = Color(0xFF9E9E9E);

  /// 등락 0, 데이터 없음 등 방향이 없는 값.
  static const neutral = Color(0xFF9E9E9E);

  /// 모달 뒤 화면을 어둡게 가리는 배경.
  static const backdrop = Color.fromRGBO(0, 0, 0, 0.5);

  /// 오류 안내 문구(B-b 키 거절, B·B-a 저장 실패, rare-level 입력 오류).
  static const error = Color(0xFFEF5350);

  /// [⚙] 알림 꺼짐 점.
  static const badge = Color(0xFFEF5350);

  /// 휴장 달력 오늘 테두리(D-143).
  static const today = Color(0xFFFFFFFF);
}

/// 휴장 달력 시장별 점·꼬리표 색(D-143). 등락 색·차트 선과 따로 본다.
abstract final class MarketColors {
  static const cme = Color(0xFFFFA726);
  static const krx = Color(0xFF4FC3F7);
  static const nyse = Color(0xFF81C784);
}

/// 차트 색.
abstract final class ChartColors {
  static const grid = Color(0xFF2A2A2A);
  static const tick = Color(0xFF9E9E9E);
  static const crosshair = Color(0xFFFFFFFF);

  /// 십자선 점선은 라벨 상자(흰색)보다 옅게 해 봉·선을 덜 가린다.
  static const crosshairLine = Color.fromRGBO(255, 255, 255, 0.6);
  static const crosshairText = Color(0xFF000000);

  /// 마지막 봉 종가 라벨·점선(흰색)과 보이는 마지막 봉 종가 라벨·점선(회색)(screens.md C-a).
  static const lastPrice = Color(0xFFFFFFFF);
  static const currentPrice = Color(0xFF9E9E9E);

  /// 노랑은 이평선 전용(screens.md C-a).
  static const movingAverage = Color(0xFFFFD54F);

  /// rare-level 선은 레벨 값이 아니라 순위로 고른다.
  /// 0 = 가장 덜 드문 레벨(옅음) → 4 = 가장 드문 레벨(진함).
  static const rareLevels = [
    Color(0xFF4A3D66),
    Color(0xFF62508A),
    Color(0xFF7C62B0),
    Color(0xFF9A72D8),
    Color(0xFFB884FF),
  ];

  /// 롤 표시는 청록(이평선 노랑·rare-level 보라·등락 색과 겹치지 않음).
  /// 한국형·미국형 롤 기간 음영, 대표월물 전환일 세로 점선.
  static const rollShade = Color.fromRGBO(77, 208, 225, 0.12);
  static const rollSwitch = Color.fromRGBO(77, 208, 225, 0.45);

  /// 보이는 구간 최고가·최저가 꼬리표.
  static const extremeTag = Color(0xFFE0E0E0);

  /// C-b 커브: 기준일은 흰색 실선, 비교일은 회색 점선(screens.md C-b).
  static const curveBase = Color(0xFFFFFFFF);
  static const curveCurrent = Color(0xFF9E9E9E);

  /// C-c 월물 선은 만기순 순번으로 고른다. 근월물→원월물을 빨·주·노·초·파 무지개 순서로 읽는다.
  /// 6번째는 대표월물 안전장치 월물(D-092).
  static const contractLines = [
    Color(0xFFEF5350),
    Color(0xFFFFA726),
    Color(0xFFFFEE58),
    Color(0xFF66BB6A),
    Color(0xFF42A5F5),
    Color(0xFF90A4AE),
  ];
}

/// 여백(logical px = RN pt).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

/// 글자 크기.
abstract final class AppFontSize {
  static const double caption = 12;
  static const double body = 14;
  static const double title = 17;
  static const double headline = 22;
}

/// 모서리 반경.
abstract final class AppRadius {
  static const double sm = 4;
  static const double md = 6;
}

/// 크기.
abstract final class AppSize {
  /// 최소 터치 영역(Apple HIG 44pt).
  static const double touchTarget = 44;
}
