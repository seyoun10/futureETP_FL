import 'package:futureetp/core/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

TextStyle _plain(double size, FontWeight weight) => TextStyle(
  inherit: false,
  fontSize: size,
  fontWeight: weight,
  textBaseline: TextBaseline.alphabetic,
);

/// 글자 기하(크기·굵기만). Material 3 기본 기하는 줄 높이 배수(`height` 1.43 등)와
/// 자간(`letterSpacing` 0.25 등)을 갖고, 화면 `TextStyle`이 이를 물려받아 RN보다 줄이 높고
/// 글자가 벌어진다. RN `Text`처럼 줄 높이는 글꼴 고유 값, 자간은 0으로 둔다.
/// 한국어는 `tall` 기하를 쓰므로 세 기하를 모두 같게 한다.
final _rnGeometry = TextTheme(
  displayLarge: _plain(57, FontWeight.w400),
  displayMedium: _plain(45, FontWeight.w400),
  displaySmall: _plain(36, FontWeight.w400),
  headlineLarge: _plain(32, FontWeight.w400),
  headlineMedium: _plain(28, FontWeight.w400),
  headlineSmall: _plain(24, FontWeight.w400),
  titleLarge: _plain(22, FontWeight.w400),
  titleMedium: _plain(16, FontWeight.w500),
  titleSmall: _plain(14, FontWeight.w500),
  labelLarge: _plain(14, FontWeight.w500),
  labelMedium: _plain(12, FontWeight.w500),
  labelSmall: _plain(11, FontWeight.w500),
  bodyLarge: _plain(16, FontWeight.w400),
  bodyMedium: _plain(14, FontWeight.w400),
  bodySmall: _plain(12, FontWeight.w400),
);

/// 앱 테마(다크 전용, D-031). Material 위젯 기본 색을 토큰에 맞춘다.
/// RN처럼 버튼은 `surfaceSelected` 바탕에 본문 글자색, 입력 칸은 `surface` 바탕이다.
ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.surfaceSelected,
    onPrimary: AppColors.text,
    secondary: AppColors.surfaceSelected,
    onSecondary: AppColors.text,
    secondaryContainer: AppColors.surfaceSelected,
    onSecondaryContainer: AppColors.text,
    surface: AppColors.background,
    onSurface: AppColors.text,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: AppColors.background,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.surface,
    surfaceContainerHigh: AppColors.surface,
    surfaceContainerHighest: AppColors.surface,
    error: AppColors.error,
    outline: AppColors.border,
    outlineVariant: AppColors.separator,
    scrim: AppColors.backdrop,
  );
  return ThemeData(
    colorScheme: scheme,
    typography: Typography.material2021(
      colorScheme: scheme,
      englishLike: _rnGeometry,
      dense: _rnGeometry,
      tall: _rnGeometry,
    ),
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.separator,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      surfaceTintColor: AppColors.background,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSize.touchTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
  );
}
