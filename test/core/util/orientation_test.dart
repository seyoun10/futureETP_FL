import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Object?> calls;
  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'SystemChrome.setPreferredOrientations') {
            calls.add(call.arguments);
          }
          return null;
        });
  });

  test('세로는 위쪽만, 가로는 양쪽', () async {
    await lockPortrait();
    await lockLandscape();
    expect(calls, [
      ['DeviceOrientation.portraitUp'],
      ['DeviceOrientation.landscapeLeft', 'DeviceOrientation.landscapeRight'],
    ]);
  });

  test('잠금 실패는 무시한다', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async => throw PlatformException(code: 'denied'),
        );
    await expectLater(lockLandscape(), completes);
  });

  testWidgets('창 모양으로 가로를 판단한다', (tester) async {
    late bool landscape;
    Future<void> pumpAt(Size size) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: size),
          child: Builder(
            builder: (context) {
              landscape = isLandscape(context);
              return const SizedBox();
            },
          ),
        ),
      );
    }

    await pumpAt(const Size(400, 800));
    expect(landscape, isFalse);
    await pumpAt(const Size(800, 400));
    expect(landscape, isTrue);
  });
}
