import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

// 앱은 세로로 고정하고, C-a~C-c에서만 [⟲]로 가로를 잠근다(screens.md C, D-076).
// RN `apps/mobile/src/lib/orientation.ts`.

/// 기기가 잠금을 거부해도(iPad 크기 조절 등) 화면은 창 모양을 따르므로 실패는 무시한다.
Future<void> _lock(List<DeviceOrientation> orientations) async {
  try {
    await SystemChrome.setPreferredOrientations(orientations);
  } on Object catch (error) {
    debugPrint('[orientation] lock failed: $error');
  }
}

/// 세로(위쪽)로 잠근다. 앱 시작, ETP 탭, C 밖으로 나갈 때.
Future<void> lockPortrait() => _lock(const [DeviceOrientation.portraitUp]);

/// 가로(양쪽)로 잠근다. C-a~C-c [⟲].
Future<void> lockLandscape() => _lock(const [
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);

/// 레이아웃은 잠금 상태가 아니라 실제 창 모양으로 정한다.
bool isLandscape(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width > size.height;
}
