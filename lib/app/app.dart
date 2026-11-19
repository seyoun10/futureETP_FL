import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/app/router.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 앱 문구 + Flutter 기본 문구. 기본 문구는 flutter_localizations가 아니라
/// material_ui의 것을 써야 material_ui 위젯이 찾는다.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// 앱 루트. 테마 토큰은 3단계 테마 항목에서 넣는다.
class App extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    onGenerateTitle: (context) => 'futureETP',
    // 다크 전용(D-031)
    theme: ThemeData(brightness: Brightness.dark),
    // 앱 안 언어 설정을 따른다(기본은 기기 언어, D-033, D-073)
    locale: ref.watch(displaySettingsProvider.select((s) => s.locale)),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: ref.watch(routerProvider),
  );
}
