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
  String get devChartSpikeTitle => 'Chart spike';

  @override
  String devChartSpikeStats(int fps, String worst, int bars) {
    return '${fps}fps · worst ${worst}ms · $bars bars';
  }

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

  @override
  String get accessKeyTitle => 'Access key';

  @override
  String get accessKeyGuide =>
      'Enter the server access key. Scan the QR shown by the key script on your Mac, or paste the key.';

  @override
  String get accessKeyPastePlaceholder => 'Paste key';

  @override
  String get accessKeySubmit => 'Confirm';

  @override
  String get accessKeyVerifying => 'Verifying';

  @override
  String get accessKeyBadFormat => 'The key format is invalid.';

  @override
  String get accessKeyRejected => 'The key was not accepted.';

  @override
  String get accessKeyScanQr => 'Scan QR';

  @override
  String get accessKeyScannerLabel => 'QR camera';

  @override
  String get accessKeyNotKeyQr => 'This QR is not an access key.';

  @override
  String get accessKeyCameraUnavailable =>
      'The camera is unavailable. Paste the key instead.';

  @override
  String get cancel => 'Cancel';

  @override
  String get errorUnauthorized => 'The access key is missing or invalid.';

  @override
  String get errorRateLimited => 'Too many requests. Please try again shortly.';

  @override
  String get errorValidationFailed => 'The input is invalid.';

  @override
  String get errorNotFound => 'Data not found.';

  @override
  String get errorInternal =>
      'Something went wrong on the server. Please try again shortly.';

  @override
  String get errorNetwork => 'Unable to connect to the network.';

  @override
  String get errorTimeout =>
      'The server is taking too long. Please try again shortly.';

  @override
  String get errorSchemaMismatch =>
      'The app and server versions do not match. Please update the app.';

  @override
  String get loading => 'Loading';

  @override
  String freshnessAsOf(String time) {
    return 'As of $time';
  }

  @override
  String freshnessTradeDate(String date) {
    return 'Trade date $date';
  }

  @override
  String get freshnessDelayed => 'Delayed';

  @override
  String get marketStateOpen => 'Open';

  @override
  String get marketStateClosed => 'Closed';

  @override
  String get marketStateSettlementPending => 'Settlement pending';
}
