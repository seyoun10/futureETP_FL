import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/health.dart';

final FutureProvider<Health> healthProvider =
    FutureProvider.autoDispose<Health>(
      (ref) => ref.watch(apiClientProvider).getHealth(),
    );
