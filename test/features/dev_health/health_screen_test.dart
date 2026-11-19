import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/health.dart';
import 'package:futureetp/features/dev_health/health_provider.dart';
import 'package:futureetp/features/dev_health/health_screen.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Widget _app(Future<Health> Function() load) => ProviderScope(
  overrides: [healthProvider.overrideWith((ref) => load())],
  child: const MaterialApp(
    locale: Locale('ko'),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: HealthScreen(),
  ),
);

void main() {
  testWidgets('연결되면 status와 commit을 보인다', (tester) async {
    await tester.pumpWidget(
      _app(() async => const Health(status: 'ok', commit: 'abc')),
    );
    await tester.pumpAndSettle();
    expect(find.text('연결됨 (status ok, commit abc)'), findsOneWidget);
  });

  testWidgets('실패하면 오류 줄을 보인다', (tester) async {
    await tester.pumpWidget(
      _app(() async => throw const FormatException('bad')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('health-error')), findsOneWidget);
  });
}
