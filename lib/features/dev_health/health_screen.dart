import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/config/app_config.dart';
import 'package:futureetp/features/dev_health/health_provider.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 2단계 임시 화면: 서버 `GET /v1/health` 연결 확인. 3단계 화면이 생기면 지운다.
class HealthScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final health = ref.watch(healthProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.devHealthTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(l10n.devHealthVariant(config.variant.name)),
            Text(l10n.devHealthServer(config.apiUrl)),
            switch (health) {
              AsyncData(:final value) => Text(
                l10n.devHealthOk(value.status, value.commit ?? '-'),
                key: const Key('health-ok'),
              ),
              AsyncError(:final error) => Text(
                l10n.devHealthFailed('$error'),
                key: const Key('health-error'),
              ),
              _ => const LinearProgressIndicator(),
            },
            OutlinedButton(
              onPressed: () => ref.invalidate(healthProvider),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
