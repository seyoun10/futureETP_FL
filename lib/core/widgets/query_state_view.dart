import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 조회 화면 상태 분기(원본 architecture.md 화면 표시, RN `QueryStateView`).
///
/// 데이터가 한 번이라도 있으면 새로고침이 실패해도 그 데이터를 계속 보여 주고
/// (기준 시각 줄로 오래됨을 알림), 처음 로딩 실패만 오류 화면이다.
/// 재시도 중(로딩)에는 오류 대신 스켈레톤이다.
class QueryStateView<T> extends StatelessWidget {
  const new({
    super.key,
    required this.value,
    required this.onRetry,
    required this.builder,
    this.skeleton,
  });

  final AsyncValue<T> value;

  /// [다시 시도]. 보통 `ref.invalidate(provider)`.
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T data) builder;

  /// 화면 모양에 맞춘 스켈레톤. 없으면 [LoadingView].
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) return builder(context, value.requireValue);
    if (value case AsyncError(:final error, isLoading: false)) {
      return ErrorView(error: error, onRetry: onRetry);
    }
    return skeleton ?? const LoadingView();
  }
}

/// 공용 막대 스켈레톤 + 가운데 스피너.
class LoadingView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).loading,
    child: ColoredBox(
      color: AppColors.background,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              children: [
                for (final width in const [0.9, 0.6, 0.75])
                  FractionallySizedBox(
                    widthFactor: width,
                    child: Container(
                      height: AppSpacing.xl,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Positioned.fill(child: CenterSpinner()),
        ],
      ),
    ),
  );
}

/// 첫 조회 중 스켈레톤 위 가운데에 겹치는 스피너. 응답이 늦어도 불러오는 중임이 보이게 한다.
/// 접근성 라벨은 감싸는 스켈레톤이 갖고, 터치는 막지 않는다.
class CenterSpinner extends StatelessWidget {
  const new({super.key});

  static const spinnerKey = Key('center-spinner');

  @override
  Widget build(BuildContext context) => const IgnorePointer(
    child: Center(
      child: ExcludeSemantics(
        child: CircularProgressIndicator(
          key: spinnerKey,
          color: AppColors.textSecondary,
        ),
      ),
    ),
  );
}

/// 안내 문구 + [다시 시도]. 문구는 에러 code로 고르고, AppError가 아니면 INTERNAL 문구다(D-042).
class ErrorView extends StatelessWidget {
  const new({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            children: [
              Text(
                errorText(l10n, error),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: AppFontSize.body,
                ),
              ),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.text,
                  minimumSize: const Size(0, AppSize.touchTarget),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  textStyle: const TextStyle(fontSize: AppFontSize.body),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
