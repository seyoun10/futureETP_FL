import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:futureetp/core/storage/secure_storage.dart';

/// 요청 헤더 이름(D-120).
const deviceIdHeader = 'X-Device-Id';

final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

/// UUID v4 소문자 문자열.
String createUuidV4([Random? random]) {
  final rng = random ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// 기기 키(installation ID, D-120). 서버가 설정·알림을 이 값으로 기기별로 나눈다.
///
/// 접근 키와 따로 두어 키를 바꿔도 설정이 남는다. 처음 부를 때 저장된 값을 읽고,
/// 없거나 UUID가 아니면 새로 만들어 저장한다. 저장소 읽기·쓰기가 실패해도
/// 이번 실행은 만든 값을 쓴다(다음 실행은 새 기기로 보인다).
class DeviceIdStore {
  new(this._storage, {this._random});

  static const storageKey = 'device-id';

  final FlutterSecureStorage _storage;
  final Random? _random;
  Future<String>? _cached;

  Future<String> get() => _cached ??= _load();

  Future<String> _load() async {
    String? stored;
    try {
      stored = await _storage.read(key: storageKey);
    } on Object catch (error) {
      debugPrint('[device] failed to read device id: $error');
    }
    if (stored != null && _uuidV4.hasMatch(stored)) return stored;

    final id = createUuidV4(_random);
    try {
      await _storage.write(key: storageKey, value: id);
    } on Object catch (error) {
      debugPrint('[device] failed to save device id: $error');
    }
    return id;
  }
}

final deviceIdStoreProvider = Provider<DeviceIdStore>(
  (ref) => DeviceIdStore(ref.watch(secureStorageProvider)),
);
