import 'package:futureetp/core/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

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
