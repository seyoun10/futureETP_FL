// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get devHealthTitle => '서버 연결 확인';

  @override
  String devHealthVariant(String variant) {
    return '변형: $variant';
  }

  @override
  String devHealthServer(String url) {
    return '서버: $url';
  }

  @override
  String devHealthOk(String status, String commit) {
    return '연결됨 (status $status, commit $commit)';
  }

  @override
  String devHealthFailed(String error) {
    return '연결 실패: $error';
  }

  @override
  String get retry => '다시 시도';
}
