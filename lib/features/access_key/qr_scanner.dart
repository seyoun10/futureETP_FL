import 'dart:async';

import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// B-b의 QR 읽기 영역(D-078). 카메라 권한은 mobile_scanner가 시작할 때 요청한다.
class QrScanner extends StatefulWidget {
  const new({
    required this.onScanned,
    required this.onUnavailable,
    required this.onCancel,
    super.key,
  });

  /// 읽은 QR 내용. 받아들였으면 true를 돌려주고, 그 뒤 들어오는 QR은 무시한다.
  final bool Function(String data) onScanned;

  /// 카메라를 열지 못함(권한 거부, iOS 시뮬레이터처럼 카메라 없음).
  final VoidCallback onUnavailable;
  final VoidCallback onCancel;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final _controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);

  // 카메라는 QR이 보이는 동안 계속 이벤트를 보내므로 한 번만 넘긴다.
  var _accepted = false;
  var _reportedUnavailable = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final data = barcode.rawValue;
      if (_accepted || data == null) continue;
      _accepted = widget.onScanned(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Semantics(
              label: l10n.accessKeyScannerLabel,
              child: MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
                placeholderBuilder: (context) =>
                    const ColoredBox(color: Colors.black),
                // 권한 거부·카메라 없음: 닫고 붙여넣기 안내. 그리는 중이라 다음 프레임에 알린다.
                errorBuilder: (context, error) {
                  if (!_reportedUnavailable) {
                    _reportedUnavailable = true;
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => widget.onUnavailable(),
                    );
                  }
                  return const ColoredBox(color: Colors.black);
                },
              ),
            ),
          ),
        ),
        OutlinedButton(onPressed: widget.onCancel, child: Text(l10n.cancel)),
      ],
    );
  }
}
