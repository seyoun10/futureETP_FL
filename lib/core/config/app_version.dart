import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 설치한 빌드의 버전. 서버에 보내는 `appVersion`에는 `fl-` 접두사를 붙인다(FL-002).
typedef AppVersion = ({String version, String build});

/// `pubspec.yaml`의 `version`(이름+빌드 번호). 테스트에서 덮어쓴다.
final appVersionProvider = FutureProvider<AppVersion>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return (version: info.version, build: info.buildNumber);
});
