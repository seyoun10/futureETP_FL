import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/theme/app_theme.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 화면 위젯 테스트용 앱 껍데기. 앱과 같은 테마(`buildAppTheme`)와 문구 설정을 쓴다.
///
/// 기본 테마로 돌리면 앱 테마에서만 나는 레이아웃 문제를 놓친다(B-a 권한 배너 버튼, FL-033).
/// [platform]은 플랫폼별 동작(Cupertino/Material 분기)을 볼 때만 준다.
Widget testApp({
  required Widget home,
  Locale? locale,
  TargetPlatform? platform,
}) {
  final theme = buildAppTheme();
  return MaterialApp(
    theme: platform == null ? theme : theme.copyWith(platform: platform),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: home,
  );
}
