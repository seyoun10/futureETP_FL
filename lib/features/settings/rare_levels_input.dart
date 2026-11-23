import 'dart:async';

import 'package:flutter/services.dart';
import 'package:futureetp/core/api/models/settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

enum _Problem { invalid, duplicate }

/// 칸 글자를 숫자로. 기기에 따라 소수점이 쉼표로 들어온다. 숫자가 아니면 NaN.
double parseRareLevel(String text) {
  final normalized = text.trim().replaceFirst(',', '.');
  return RegExp(r'^\d+(\.\d+)?$').hasMatch(normalized)
      ? double.parse(normalized)
      : double.nan;
}

/// 저장된 값의 칸 글자(`1`·`2.5`).
String formatRareLevel(double level) => level == level.roundToDouble()
    ? level.toInt().toString()
    : level.toString();

_Problem? _findProblem(List<double> values) {
  if (values.any((v) => !isValidRareLevel(v))) return _Problem.invalid;
  if (hasDuplicateRareLevels(values)) return _Problem.duplicate;
  return null;
}

/// rare-level 5칸(screens.md B, D-083, RN `RareLevelsInput`).
///
/// 키패드가 닫힐 때(다섯 칸 모두 포커스를 잃거나 키패드가 내려갈 때) 5개가 모두 맞으면
/// 오름차순으로 정렬해 저장하고, 아니면 오류를 보여 주고 저장하지 않는다. 칸 사이를 옮기는 동안은
/// 저장하지 않아 순서대로 입력하는 중에 정렬된 값으로 칸이 바뀌지 않는다.
class RareLevelsInput extends StatefulWidget {
  const new({
    super.key,
    required this.levels,
    required this.onSave,
    this.description,
  });

  /// 조회 중이면 null(입력 막음).
  final List<double>? levels;
  final ValueChanged<List<double>> onSave;

  /// 행 아래 한 줄 설명(입력 범위 안내 아래).
  final String? description;

  @override
  State<RareLevelsInput> createState() => _RareLevelsInputState();
}

class _RareLevelsInputState extends State<RareLevelsInput> {
  final List<TextEditingController> _controllers = [
    for (var i = 0; i < rareLevelCount; i++) TextEditingController(),
  ];
  final List<FocusNode> _focusNodes = [
    for (var i = 0; i < rareLevelCount; i++) FocusNode(),
  ];

  /// 고치는 중인지. 아니면 칸이 서버(화면) 값을 따른다.
  var _editing = false;
  _Problem? _problem;
  var _keyboardOpen = false;

  @override
  void initState() {
    super.initState();
    _showLevels();
    for (final (i, node) in _focusNodes.indexed) {
      node.addListener(() => _onFocusChange(i));
    }
  }

  @override
  void didUpdateWidget(RareLevelsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing) _showLevels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Android 뒤로 버튼처럼 포커스를 둔 채 키패드만 내려가도 닫힌 것으로 본다
    final open = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (_keyboardOpen && !open && _focusNodes.any((n) => n.hasFocus)) {
      for (final node in _focusNodes) {
        node.unfocus();
      }
    }
    _keyboardOpen = open;
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _showLevels() {
    final levels = widget.levels;
    for (final (i, c) in _controllers.indexed) {
      c.text = levels == null || i >= levels.length
          ? ''
          : formatRareLevel(levels[i]);
    }
  }

  void _onFocusChange(int index) {
    final node = _focusNodes[index];
    if (node.hasFocus) {
      final c = _controllers[index];
      c.selection = TextSelection(baseOffset: 0, extentOffset: c.text.length);
      return;
    }
    // 다른 칸으로 옮기는 중이면 그 칸이 곧 포커스를 받는다
    scheduleMicrotask(() {
      if (mounted && !_focusNodes.any((n) => n.hasFocus)) _commit();
    });
  }

  void _commit() {
    final levels = widget.levels;
    if (!_editing || levels == null) return;
    final values = [for (final c in _controllers) parseRareLevel(c.text)];
    final problem = _findProblem(values);
    if (problem != null) {
      setState(() => _problem = problem);
      return;
    }
    final sorted = values.map(roundRareLevel).toList()..sort();
    setState(() => _editing = false);
    _showLevels();
    var changed = false;
    for (var i = 0; i < sorted.length; i++) {
      if (i >= levels.length || sorted[i] != levels[i]) changed = true;
    }
    if (changed) widget.onSave(sorted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final min = formatRareLevel(rareLevelMin);
    final max = formatRareLevel(rareLevelMax);
    final hint = switch (_problem) {
      _Problem.invalid => l10n.settingsRareLevelInvalid(min, max),
      _Problem.duplicate => l10n.settingsRareLevelDuplicate(rareLevelCount),
      null => l10n.settingsRareLevelHint(min, max, rareLevelCount),
    };
    final android = Theme.of(context).platform == TargetPlatform.android;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.xs,
        children: [
          Row(
            spacing: AppSpacing.xs,
            children: [
              Expanded(
                child: Text(
                  l10n.settingsRareLevels,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: AppFontSize.body,
                  ),
                ),
              ),
              for (final (i, c) in _controllers.indexed)
                SizedBox(
                  width: 48,
                  child: TextField(
                    key: Key('rare-level-$i'),
                    controller: c,
                    focusNode: _focusNodes[i],
                    enabled: widget.levels != null,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    // iOS는 화면의 [완료] 줄로 닫는다
                    textInputAction: android ? TextInputAction.done : null,
                    inputFormatters: [LengthLimitingTextInputFormatter(4)],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: AppFontSize.body,
                    ),
                    decoration: InputDecoration(
                      semanticCounterText: '',
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        borderSide: BorderSide.none,
                      ),
                      constraints: const BoxConstraints(minHeight: 36),
                    ),
                    onChanged: (_) => setState(() {
                      _editing = true;
                      _problem = null;
                    }),
                  ),
                ),
            ],
          ),
          Text(
            hint,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _problem == null
                  ? AppColors.textSecondary
                  : AppColors.error,
              fontSize: AppFontSize.caption,
            ),
          ),
          if (widget.description case final d?)
            Text(
              d,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppFontSize.caption,
              ),
            ),
        ],
      ),
    );
  }
}
