import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/l10n/app_localizations.dart';

/// 화면에 보일 에러 문구. [AppError]가 아니면 INTERNAL 문구다(D-042).
String errorText(AppLocalizations l10n, Object error) =>
    switch (error is AppError ? error.code : AppErrorCode.internal) {
      AppErrorCode.unauthorized => l10n.errorUnauthorized,
      AppErrorCode.rateLimited => l10n.errorRateLimited,
      AppErrorCode.validationFailed => l10n.errorValidationFailed,
      AppErrorCode.notFound => l10n.errorNotFound,
      AppErrorCode.internal => l10n.errorInternal,
      AppErrorCode.network => l10n.errorNetwork,
      AppErrorCode.timeout => l10n.errorTimeout,
      AppErrorCode.schemaMismatch => l10n.errorSchemaMismatch,
    };
