import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

var _open = false;

/// 로딩이 실패하거나 시간 안에 끝나지 않았을 때의 공통 안내(D-138, D-139, RN `showFailedAlert`).
/// [확인]으로 닫기만 하고, 다시 하는 방법(다시 당기기, 차트 다시 끌기)은 본문에 적는다.
/// 떠 있는 동안 또 부르면 겹쳐 띄우지 않는다. iOS는 Cupertino 모양이다.
void showFailedAlert(BuildContext context, String title, String message) {
  if (_open) return;
  _open = true;
  final confirm = AppLocalizations.of(context).confirm;
  unawaited(
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(message),
        actions: [
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(confirm),
          ),
        ],
      ),
    ).whenComplete(() => _open = false),
  );
}

/// 플랫폼에 맞는 대화상자 버튼.
Widget adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
}) => switch (Theme.of(context).platform) {
  TargetPlatform.iOS || TargetPlatform.macOS => CupertinoDialogAction(
    onPressed: onPressed,
    child: child,
  ),
  _ => TextButton(onPressed: onPressed, child: child),
};
