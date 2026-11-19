import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 접근 키·installation ID를 두는 기기 보안 저장소(D-043, D-044, FL-015).
///
/// iOS는 이 기기에서 첫 잠금 해제 뒤 읽을 수 있고 백업으로 다른 기기에 옮겨지지 않는다.
/// Android는 자동 백업을 끈다(`allowBackup="false"`, 복원된 암호문은 읽을 수 없음).
const appSecureStorage = FlutterSecureStorage(
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => appSecureStorage,
);
