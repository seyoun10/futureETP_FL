import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/notification_taps.dart';
import 'package:futureetp/app/router.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/push/push_service.dart';

import '../helpers/fake_push.dart';

Future<ProviderContainer> _container(FakePushService push) async {
  final container = ProviderContainer(
    overrides: [
      storedAccessKeyProvider.overrideWithValue('key'),
      pushServiceProvider.overrideWithValue(push),
    ],
  );
  addTearDown(container.dispose);
  container.listen(notificationTapsProvider, (_, _) {});
  await pumpEventQueue();
  return container;
}

String _location(ProviderContainer c) =>
    c.read(routerProvider).routeInformationProvider.value.uri.toString();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('앱을 실행한 rare 레벨 알림이면 그 원자재 C-a로 간다', () async {
    final c = await _container(
      FakePushService(initialTap: {'type': 'RARE_LEVEL', 'commodity': 'GC'}),
    );
    expect(_location(c), '/commodity/GC');
  });

  test('앱 사용 중 누른 알림: rare 레벨은 C-a, 그 밖은 A', () async {
    final push = FakePushService();
    final c = await _container(push);
    push.taps.add({'type': 'RARE_LEVEL', 'commodity': 'NG'});
    await pumpEventQueue();
    expect(_location(c), '/commodity/NG');
    push.taps.add({'type': 'ETP_CANDIDATES'});
    await pumpEventQueue();
    expect(_location(c), AppRoutes.home);
  });
}
