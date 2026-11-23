import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  // Material 3 기본 기하(줄 높이 1.43·자간 0.25 등)를 물려받으면 RN보다 줄이 높고 글자가 벌어진다
  for (final locale in [const Locale('ko'), const Locale('en')]) {
    testWidgets('$locale 글자 기하에 줄 높이 배수·자간이 없다', (tester) async {
      await tester.pumpWidget(testApp(home: const Scaffold(), locale: locale));
      final theme = Theme.of(tester.element(find.byType(Scaffold)));
      for (final style in [
        theme.textTheme.bodyMedium!,
        theme.textTheme.bodySmall!,
        theme.textTheme.titleMedium!,
        theme.textTheme.labelLarge!,
      ]) {
        expect(style.height, isNull);
        expect(style.letterSpacing, anyOf(isNull, 0));
      }
      expect(theme.textTheme.bodyMedium!.fontSize, 14);
    });
  }
}
