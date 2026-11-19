import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/device_id.dart';

final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  test('createUuidV4는 UUID v4 형식이다', () {
    final random = Random(1);
    for (var i = 0; i < 100; i++) {
      expect(createUuidV4(random), matches(_uuidV4));
    }
  });

  test('저장된 값이 없으면 만들어 저장하고 다음에도 같은 값', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = FlutterSecureStorage();
    final id = await DeviceIdStore(storage).get();
    expect(id, matches(_uuidV4));
    expect(await storage.read(key: DeviceIdStore.storageKey), id);
    // 새 실행(새 store)도 저장된 값을 읽는다
    expect(await DeviceIdStore(storage).get(), id);
  });

  test('저장된 값이 UUID가 아니면 새로 만든다', () async {
    FlutterSecureStorage.setMockInitialValues({
      DeviceIdStore.storageKey: 'broken',
    });
    const storage = FlutterSecureStorage();
    final id = await DeviceIdStore(storage).get();
    expect(id, isNot('broken'));
    expect(id, matches(_uuidV4));
    expect(await storage.read(key: DeviceIdStore.storageKey), id);
  });

  test('한 store는 동시에 불러도 같은 값', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final store = DeviceIdStore(const FlutterSecureStorage());
    final ids = await Future.wait([store.get(), store.get()]);
    expect(ids[0], ids[1]);
  });
}
