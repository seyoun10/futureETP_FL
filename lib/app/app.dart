import 'package:futureetp/features/dev_health/health_screen.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 앱 문구 + Flutter 기본 문구. 기본 문구는 flutter_localizations가 아니라
/// material_ui의 것을 써야 material_ui 위젯이 찾는다.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// 앱 루트. 라우터(go_router)·테마 토큰은 3단계에서 넣는다.
class App extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).devHealthTitle,
    // 다크 전용(D-031)
    theme: ThemeData(brightness: Brightness.dark),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const HealthScreen(),
  );
}
