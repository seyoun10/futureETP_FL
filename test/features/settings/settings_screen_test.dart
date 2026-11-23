import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/features/settings/rare_levels_input.dart';
import 'package:futureetp/features/settings/settings_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/display_store.dart';
import '../../helpers/settings_server.dart';
import '../../helpers/test_app.dart';

late SharedPreferencesWithCache _displayStore;
late List<String> _opened;

Future<SettingsServer> _pump(
  WidgetTester tester, {
  Map<String, Object?>? initial,
  TargetPlatform platform = TargetPlatform.android,
}) async {
  final server = SettingsServer(initial: initial);
  // 목록 전체가 한 화면에 들어오게 한다
  tester.view
    ..physicalSize = const Size(800, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        ...server.overrides(_displayStore),
        deviceLocaleProvider.overrideWithValue(const Locale('ko', 'KR')),
      ],
      child: testApp(
        platform: platform,
        locale: const Locale('en'),
        home: SettingsScreen(
          onOpenAlerts: () => _opened.add('alerts'),
          onOpenAccessKey: () => _opened.add('accessKey'),
          onOpenDataSources: () => _opened.add('dataSources'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return server;
}

Finder _field(int i) => find.byKey(Key('rare-level-$i'));

String _fieldText(WidgetTester tester, int i) =>
    tester.widget<TextField>(_field(i)).controller!.text;

/// 다섯 칸에 차례로 넣고 키패드를 닫는다(포커스를 모두 놓는다).
Future<void> _enterLevels(WidgetTester tester, List<String> values) async {
  for (final (i, v) in values.indexed) {
    await tester.tap(_field(i));
    await tester.enterText(_field(i), v);
  }
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
}

/// 세그먼트 칸이 골라져 있는지(고른 칸만 surfaceSelected 바탕).
bool _selected(WidgetTester tester, String label) =>
    tester
        .widget<Material>(
          find
              .ancestor(of: find.text(label), matching: find.byType(Material))
              .first,
        )
        .color ==
    AppColors.surfaceSelected;

void main() {
  setUp(() async {
    _displayStore = await openTestDisplayStore(
      stored: '{"language":"en","upDownStyle":"kr"}',
    );
    _opened = [];
  });

  testWidgets('묶음과 서버 값, 알림 꺼짐, 앱 버전 줄을 그린다', (tester) async {
    await _pump(tester);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Disparity chart'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(_selected(tester, 'Front month'), isTrue);
    expect(_selected(tester, 'KR-style'), isFalse);
    expect(
      [for (var i = 0; i < 5; i++) _fieldText(tester, i)],
      ['1', '2', '4', '8', '16'],
    );
    // 알림 대상이 없으면 끔
    expect(find.text('Off'), findsOneWidget);
    expect(find.text('Set'), findsOneWidget);
    expect(
      find.textContaining('App version: fl-1.0.0 (build 1) · '),
      findsOneWidget,
    );
  });

  testWidgets('고르면 그 필드만 PATCH하고, 칸은 바로 바뀐다', (tester) async {
    final server = await _pump(tester);
    await tester.tap(find.text('KR-style'));
    await tester.pump();
    expect(_selected(tester, 'KR-style'), isTrue);
    await tester.pumpAndSettle();
    expect(server.patches, [
      {'basis': 'KR'},
    ]);
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    expect(server.patches.last, {'maPeriod': 20});
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(server.patches.last, {'window': 'ALL'});
  });

  testWidgets('언어는 기기 먼저 바꾸고 서버에도 보낸다', (tester) async {
    final server = await _pump(tester);
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    expect(container.read(displaySettingsProvider).language.name, 'ko');
    expect(server.patches, [
      {'locale': 'ko'},
    ]);
  });

  testWidgets('저장이 실패하면 빨간 줄을 띄우고 서버 값으로 돌아간다', (tester) async {
    final server = await _pump(tester)
      ..failWith = ('INTERNAL', 500);
    await tester.tap(find.text('US-style'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not save.'), findsOneWidget);
    expect(_selected(tester, 'US-style'), isFalse);
    expect(_selected(tester, 'Front month'), isTrue);
    // 다시 저장하면 지운다
    server.failWith = null;
    await tester.tap(find.text('US-style'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not save.'), findsNothing);
  });

  group('rare-level', () {
    testWidgets('칸 사이를 옮기는 동안은 저장하지 않고, 닫히면 정렬해 저장한다', (tester) async {
      final server = await _pump(tester);
      await tester.tap(_field(0));
      await tester.enterText(_field(0), '30');
      await tester.tap(_field(1));
      await tester.pumpAndSettle();
      expect(server.patches, isEmpty);
      await tester.enterText(_field(1), '2,5');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(server.patches, [
        {
          'rareLevels': [2.5, 4, 8, 16, 30],
        },
      ]);
      expect(_fieldText(tester, 0), '2.5');
      expect(_fieldText(tester, 4), '30');
    });

    testWidgets('범위 밖·소수 둘째 자리·빈 칸이면 오류, 저장하지 않는다', (tester) async {
      for (final bad in ['50', '0.15', '', 'a']) {
        final server = await _pump(tester);
        await _enterLevels(tester, [bad, '2', '4', '8', '16']);
        expect(
          find.text(
            'Enter a value from 0.1 to 49.9 with at most 1 decimal place.',
          ),
          findsOneWidget,
          reason: bad,
        );
        expect(server.patches, isEmpty);
        // 입력한 값은 그대로 둔다
        expect(_fieldText(tester, 0), bad);
      }
    });

    testWidgets('중복이면 오류, 다시 입력하면 지운다', (tester) async {
      final server = await _pump(tester);
      await _enterLevels(tester, ['2', '2', '4', '8', '16']);
      expect(find.text('Enter 5 distinct values.'), findsOneWidget);
      expect(server.patches, isEmpty);
      await tester.tap(_field(0));
      await tester.enterText(_field(0), '1');
      await tester.pump();
      expect(find.text('Enter 5 distinct values.'), findsNothing);
    });

    testWidgets('값이 같으면 보내지 않는다', (tester) async {
      final server = await _pump(tester);
      await _enterLevels(tester, ['16', '8', '4', '2', '1']);
      expect(server.patches, isEmpty);
      expect(_fieldText(tester, 0), '1');
    });

    test('칸 글자 읽기·쓰기', () {
      expect(parseRareLevel(' 2,5 '), 2.5);
      expect(parseRareLevel('1e1').isNaN, isTrue);
      expect(formatRareLevel(16), '16');
      expect(formatRareLevel(0.5), '0.5');
    });

    test('반올림한 값으로 중복을 본다(shared rareLevelsSchema)', () {
      expect(hasDuplicateRareLevels([1, 1.00000000001, 2, 4, 8]), isTrue);
      expect(hasDuplicateRareLevels([1, 1.1, 2, 4, 8]), isFalse);
      expect(roundRareLevel(2.50000000001), 2.5);
    });
  });

  testWidgets('[초기화]는 확인 뒤 표시·이격도차트만 기본값으로 되돌린다', (tester) async {
    final server = await _pump(
      tester,
      initial: {
        'basis': 'US',
        'maPeriod': 20,
        'window': 'Y3',
        'rareLevels': [3, 5, 7, 9, 11],
        'alertCommodity': 'GC',
      },
    );
    await tester.tap(find.bySemanticsLabel('Reset'));
    await tester.pumpAndSettle();
    // 취소하면 그대로
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(server.patches, isEmpty);

    await tester.tap(find.bySemanticsLabel('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset').last);
    await tester.pumpAndSettle();
    // 기기 언어·지역(ko-KR) 기준. 알림 대상은 보내지 않는다
    expect(server.patches, [
      {
        'locale': 'ko',
        'basis': 'FRONT',
        'maPeriod': 100,
        'window': 'Y10',
        'rareLevels': [1, 2, 4, 8, 16],
      },
    ]);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    expect(container.read(displaySettingsProvider).upDownStyle, UpDownStyle.kr);
    expect(server.settings['alertCommodity'], 'GC');
  });

  testWidgets('행을 누르면 하위 화면으로 간다, 알림 행 값은 대상 이름', (tester) async {
    await _pump(tester, initial: {'alertCommodity': 'CL'});
    expect(find.text('Crude Oil'), findsOneWidget);
    await tester.tap(find.text('Alerts'));
    await tester.tap(find.text('Access key'));
    await tester.tap(find.text('Data sources'));
    expect(_opened, ['alerts', 'accessKey', 'dataSources']);
  });

  testWidgets('iOS는 키패드가 열리면 [완료] 줄을 띄우고 누르면 저장한다', (tester) async {
    final server = await _pump(tester, platform: TargetPlatform.iOS);
    await tester.tap(_field(4));
    await tester.enterText(_field(4), '20');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(server.patches.single['rareLevels'], [1, 2, 4, 8, 20]);
  });
}
