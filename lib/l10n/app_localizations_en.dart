// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get devHealthTitle => 'Server connection';

  @override
  String devHealthVariant(String variant) {
    return 'Variant: $variant';
  }

  @override
  String devHealthServer(String url) {
    return 'Server: $url';
  }

  @override
  String devHealthOk(String status, String commit) {
    return 'Connected (status $status, commit $commit)';
  }

  @override
  String devHealthFailed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get retry => 'Retry';
}
