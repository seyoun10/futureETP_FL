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

  @override
  String get back => 'Back';

  @override
  String get confirm => 'OK';

  @override
  String commodityName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'GC': 'Gold',
      'SI': 'Silver',
      'CL': 'Crude Oil',
      'NG': 'Natural Gas',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get commodityListAlert => 'Alert target';

  @override
  String get commodityListNoTrade => 'No trade';

  @override
  String get commodityListRefreshFailedTitle => 'Couldn\'t finish refreshing';

  @override
  String get commodityListRefreshFailedMessage =>
      'Pull down again in a moment.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAlertOffBadge => 'Alerts off';

  @override
  String get commodityRotate => 'Rotate screen';

  @override
  String get commodityTabDisparity => 'Disparity';

  @override
  String get commodityTabContracts => 'Contracts';

  @override
  String get commodityTabCurve => 'Curve';

  @override
  String get commodityTabEtps => 'ETP';

  @override
  String get basisFront => 'Front month';

  @override
  String get basisKr => 'KR-style';

  @override
  String get basisUs => 'US-style';

  @override
  String chartMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'Jan',
      '2': 'Feb',
      '3': 'Mar',
      '4': 'Apr',
      '5': 'May',
      '6': 'Jun',
      '7': 'Jul',
      '8': 'Aug',
      '9': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
      'other': '$month',
    });
    return '$_temp0';
  }

  @override
  String chartHighTag(String price, String pct, String date) {
    return 'High $price ($pct, $date)';
  }

  @override
  String chartLowTag(String price, String pct, String date) {
    return 'Low $price ($pct, $date)';
  }

  @override
  String get chartPeriodsLabel => 'Period';

  @override
  String get chartResetView => 'Back to the latest selected period';

  @override
  String get chartOlderFailedTitle => 'Couldn\'t load older data';

  @override
  String get chartOlderFailedMessage => 'Drag the chart again in a moment.';

  @override
  String disparityBasisFallback(String basis) {
    return '$basis*';
  }

  @override
  String disparityBasisInRoll(String basis) {
    return '$basis (rolling)';
  }

  @override
  String get disparityOpen => 'O';

  @override
  String get disparityHigh => 'H';

  @override
  String get disparityLow => 'L';

  @override
  String get disparityClose => 'C';

  @override
  String disparityValue(String value) {
    return 'Disparity $value';
  }

  @override
  String disparityTailUp(String pct) {
    return 'top $pct%';
  }

  @override
  String disparityTailDown(String pct) {
    return 'bottom $pct%';
  }

  @override
  String disparityFromLow(String pct) {
    return 'LC $pct';
  }

  @override
  String disparityFromHigh(String pct) {
    return 'HC $pct';
  }

  @override
  String get disparityPrevChange => 'Chg';

  @override
  String get disparityLabel => 'Disparity';

  @override
  String disparityMa(String n) {
    return 'MA$n';
  }

  @override
  String get disparityNoData => 'No bars to show.';

  @override
  String get disparityHintFront =>
      'Front month: actual prices of the most traded contract. Prices jump on the day the contract changes.';

  @override
  String disparityHintAdjusted(String basis) {
    return '$basis: adjusted prices chaining the returns of rolling contracts by the rule. They differ from actual contract prices.';
  }

  @override
  String disparityHintFallback(String basis) {
    return 'This commodity has no $basis product, so the front month is shown instead.';
  }

  @override
  String get disparityHintSameAsKr =>
      'For gold and silver, US style is the same as Korean style.';

  @override
  String get contractsProvisional => '(provisional)';

  @override
  String get contractsRollYield => 'Roll yield';

  @override
  String get contractsNoData => 'No contracts to show.';

  @override
  String chartPerYear(String pct) {
    return '$pct/yr';
  }
}
