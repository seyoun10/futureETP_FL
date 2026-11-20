import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/widgets/screen_header.dart';
import 'package:futureetp/features/access_key/qr_scanner.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// 서버에 묻기 전에 앱이 거른 경우의 안내.
enum _Notice { badFormat, notKeyQr, cameraUnavailable }

/// B-b 접근 키(screens.md B-b, D-044, D-077~D-079).
///
/// 키가 없으면 라우터가 첫 화면으로 띄운다([←] 없음). 저장하면 첫 실행은 A로,
/// 그 밖에는 들어온 화면으로 돌아간다. 키는 서버(`GET /v1/settings`)가 받은 것만 저장한다.
class AccessKeyScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AccessKeyScreen> createState() => _AccessKeyScreenState();
}

class _AccessKeyScreenState extends ConsumerState<AccessKeyScreen> {
  final _input = TextEditingController();
  late final AccessKeyNotifier _keys;
  _Notice? _notice;
  Object? _saveError;
  var _scanning = false;
  var _pending = false;

  @override
  void initState() {
    super.initState();
    _keys = ref.read(accessKeyProvider.notifier);
    _input.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _input.dispose();
    // 거절돼서 왔다가 새 키 없이 떠나면 표시를 지운다. 옛 키가 다시 거절되면 또 이 화면으로 온다.
    // 위젯 트리를 정리하는 중에는 Provider를 바꿀 수 없어 미룬다.
    scheduleMicrotask(_keys.clearRejected);
    super.dispose();
  }

  Future<void> _verifyAndSave(String key) async {
    setState(() {
      _pending = true;
      _saveError = null;
    });
    try {
      await ref.read(apiClientProvider).getSettings(token: key);
      await _keys.save(key);
    } on Object catch (error) {
      // 서버 거절·네트워크 오류·저장 실패 모두 저장하지 않고 다시 시도하게 한다.
      if (mounted) {
        setState(() {
          _pending = false;
          _saveError = error;
        });
      }
      return;
    }
    if (!mounted) return;
    setState(() => _pending = false);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _submit() {
    final key = parseAccessKey(_input.text);
    setState(() {
      _notice = key == null ? _Notice.badFormat : null;
      _saveError = null;
    });
    if (key != null) unawaited(_verifyAndSave(key));
  }

  bool _onScanned(String data) {
    final key = parseAccessKey(data, requirePrefix: true);
    if (key == null) {
      setState(() => _notice = _Notice.notKeyQr);
      return false;
    }
    setState(() {
      _notice = null;
      _scanning = false;
    });
    unawaited(_verifyAndSave(key));
    return true;
  }

  String? _errorMessage(AppLocalizations l10n, {required bool rejected}) {
    if (_notice case final notice?) {
      return switch (notice) {
        _Notice.badFormat => l10n.accessKeyBadFormat,
        _Notice.notKeyQr => l10n.accessKeyNotKeyQr,
        _Notice.cameraUnavailable => l10n.accessKeyCameraUnavailable,
      };
    }
    if (_saveError case final error?) {
      // 서버가 새 키를 거절하면 B-b 전용 문구, 그 밖은 공용 에러 문구다.
      return error is AppError && error.code == AppErrorCode.unauthorized
          ? l10n.accessKeyRejected
          : errorText(l10n, error);
    }
    // 저장된 키가 거절돼서 왔으면 새 키를 확인하기 전까지 보여 준다.
    return rejected && !_pending ? l10n.accessKeyRejected : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rejected = ref.watch(accessKeyProvider.select((s) => s.rejected));
    final error = _errorMessage(l10n, rejected: rejected);
    final canSubmit = !_pending && _input.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 키가 없어 처음 온 B-b는 스택의 처음이라 [←]가 없다(D-077)
          ScreenHeader(title: l10n.accessKeyTitle, showBack: context.canPop()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Text(l10n.accessKeyGuide),
                const SizedBox(height: AppSpacing.lg),
                if (_scanning)
                  QrScanner(
                    onScanned: _onScanned,
                    onUnavailable: () => setState(() {
                      _scanning = false;
                      _notice = _Notice.cameraUnavailable;
                    }),
                    onCancel: () => setState(() => _scanning = false),
                  )
                else
                  FilledButton.tonal(
                    onPressed: _pending
                        ? null
                        : () => setState(() {
                            _notice = null;
                            _saveError = null;
                            _scanning = true;
                          }),
                    child: Text(l10n.accessKeyScanQr),
                  ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  key: const Key('access-key-input'),
                  controller: _input,
                  enabled: !_pending,
                  // 키 값은 화면에 보여 주지 않는다(screens.md B-b)
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    hintText: l10n.accessKeyPastePlaceholder,
                  ),
                  onSubmitted: (_) => canSubmit ? _submit() : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.tonal(
                  onPressed: canSubmit ? _submit : null,
                  child: _pending
                      ? SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            semanticsLabel: l10n.accessKeyVerifying,
                          ),
                        )
                      : Text(l10n.accessKeySubmit),
                ),
                if (error != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    error,
                    key: const Key('access-key-error'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
