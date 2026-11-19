import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // 재시도 규칙(D-042): NETWORK·TIMEOUT·INTERNAL만 최대 2회
  runApp(const ProviderScope(retry: appRetry, child: App()));
}
