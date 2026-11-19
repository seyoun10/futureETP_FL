import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/app/router.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/core/theme/app_theme.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 앱 문구 + Flutter 기본 문구. 기본 문구는 flutter_localizations가 아니라
/// material_ui의 것을 써야 material_ui 위젯이 찾는다.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// 앱 루트.
class App extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 키가 있으면 서버 기기 설정을 앱 언어에 맞춘다(D-137)
    if (ref.watch(accessKeyProvider.select((s) => s.hasKey))) {
      ref.watch(deviceSettingsSyncProvider);
    }
    return MaterialApp.router(
      onGenerateTitle: (context) => 'futureETP',
      // 다크 전용(D-031)
      theme: buildAppTheme(),
      // 앱 안 언어 설정을 따른다(기본은 기기 언어, D-033, D-073)
      locale: ref.watch(displaySettingsProvider.select((s) => s.locale)),
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
