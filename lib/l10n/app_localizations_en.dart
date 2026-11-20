// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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

  @override
  String get curvePrev => 'Move base date 1 trading day earlier';

  @override
  String get curveNext => 'Move base date 1 trading day later';

  @override
  String get curveReset => 'Back to the latest base date';

  @override
  String curveRollYield(String value) {
    return 'Roll yield $value';
  }

  @override
  String get curveUnavailable => 'unavailable';

  @override
  String get curveTooltipChange => 'Change';

  @override
  String get curveNoData => 'No contracts to show.';

  @override
  String get curvePickTitle => 'Select base date';

  @override
  String curvePickRange(String min, String max) {
    return 'Available: $min – $max';
  }

  @override
  String curveMoved(String date, String weekday) {
    return 'Market closed, moved to $date ($weekday)';
  }

  @override
  String get etpMarket => 'Market';

  @override
  String get etpType => 'Type';

  @override
  String get etpLeverage => 'Leverage';

  @override
  String get etpFxHedge => 'FX hedge';

  @override
  String get etpSort => 'Sort';

  @override
  String get etpAll => 'All';

  @override
  String etpLeverageValue(String n) {
    return '${n}x';
  }

  @override
  String get etpFxHedged => 'Hedged';

  @override
  String get etpFxUnhedged => 'Unhedged';

  @override
  String get etpFxNa => 'N/A';

  @override
  String get etpSortDefault => 'Default';

  @override
  String get etpSortAum => 'AUM';

  @override
  String get etpSortTradingValue => 'Volume';

  @override
  String etpSortValue(String label, String amount) {
    return '$label $amount';
  }

  @override
  String get etpNoValue => '—';

  @override
  String get etpKrwScheme => 'si';

  @override
  String etpAmountKrx(String n) {
    return '₩$n';
  }

  @override
  String etpAmountUs(String n) {
    return '\$$n';
  }

  @override
  String get etpEmpty => 'No ETPs for this commodity.';

  @override
  String get etpNoMatch => 'No products match the filters.';

  @override
  String get etpDetailTitle => 'ETP details';

  @override
  String get etpCommodity => 'Commodity';

  @override
  String get etpIssuer => 'Issuer';

  @override
  String get etpUnderlyingIndex => 'Index';

  @override
  String get etpExpenseRatio => 'Expense ratio';

  @override
  String etpExpenseRatioValue(String n) {
    return '$n%';
  }

  @override
  String get etpListedDate => 'Listed';

  @override
  String get etpTicker => 'Ticker';

  @override
  String etpSeriesCode(String code) {
    return 'Series $code';
  }

  @override
  String etpMaturity(String date) {
    return 'Matures $date';
  }

  @override
  String get etpOpenIssuer => 'Open issuer page ↗';

  @override
  String get etpSourceNote =>
      'Collected automatically · shown in the original language';

  @override
  String get done => 'Done';

  @override
  String get settingsReset => 'Reset';

  @override
  String get settingsResetTitle => 'Reset settings';

  @override
  String get settingsResetMessage =>
      'Restore the display and disparity chart settings to their defaults? Alert settings and the access key stay as they are.';

  @override
  String get settingsAlerts => 'Alerts';

  @override
  String get settingsAccessKey => 'Access key';

  @override
  String get settingsAccessKeySaved => 'Set';

  @override
  String get settingsDataSources => 'Data sources';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsUpDownStyle => 'Up/down colors';

  @override
  String get settingsUpDownStyleKr => 'Korean';

  @override
  String get settingsUpDownStyleUs => 'US';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionDisparity => 'Disparity chart';

  @override
  String get settingsSectionOther => 'Other';

  @override
  String get settingsBasis => 'Chart basis';

  @override
  String get settingsMaPeriod => 'Moving average (days)';

  @override
  String get settingsWindow => 'Distribution period (years)';

  @override
  String get settingsWindowAll => 'All';

  @override
  String get settingsAlertOff => 'Off';

  @override
  String get settingsRareLevels => 'Rare levels (%)';

  @override
  String settingsRareLevelField(int index) {
    return 'Rare level $index';
  }

  @override
  String settingsRareLevelHint(String min, String max, int count) {
    return '$min–$max, 1 decimal place, $count distinct values';
  }

  @override
  String settingsRareLevelInvalid(String min, String max) {
    return 'Enter a value from $min to $max with at most 1 decimal place.';
  }

  @override
  String settingsRareLevelDuplicate(int count) {
    return 'Enter $count distinct values.';
  }

  @override
  String settingsSaveFailed(String reason) {
    return 'Could not save. $reason';
  }

  @override
  String get settingsLanguageDesc =>
      'Language for screens and push notifications';

  @override
  String get settingsUpDownStyleDesc =>
      'Korean: up red, down blue. US: up green, down red';

  @override
  String get settingsBasisDesc =>
      'Contracts used for the chart and alerts. Front: the most traded contract. KR/US: roll rules of Korean/US ETPs';

  @override
  String get settingsMaPeriodDesc =>
      'Moving average period that disparity is measured against';

  @override
  String get settingsWindowDesc =>
      'Past period of disparity used to judge rarity';

  @override
  String get settingsRareLevelsDesc =>
      'Bands at the top and bottom % of past disparity; you get an alert when price reaches one';

  @override
  String get settingsAlertsDesc =>
      'Commodity for rare-level alerts and quiet hours';

  @override
  String get settingsAccessKeyDesc => 'Secret key for connecting to the server';

  @override
  String get settingsDataSourcesDesc => 'Where prices and data come from';

  @override
  String settingsAppVersion(String version, String build, String variant) {
    return 'App version: $version (build $build) · $variant';
  }

  @override
  String get dataSourcesFutures => 'Futures prices';

  @override
  String get dataSourcesEtp => 'ETP';

  @override
  String get dataSourcesExchangeLabel => 'Exchange';

  @override
  String get dataSourcesExchangeValue => 'CME Group (NYMEX·COMEX)';

  @override
  String get dataSourcesSettlementLabel => 'Settlement & volume';

  @override
  String get dataSourcesSettlementValue => 'Massive, after close';

  @override
  String get dataSourcesIntradayLabel => 'Intraday';

  @override
  String get dataSourcesIntradayValue => 'Yahoo Finance, ~10 min delayed';

  @override
  String get dataSourcesHistoryLabel => 'History';

  @override
  String get dataSourcesHistoryValue => 'Databento (since 2010-06)';

  @override
  String get dataSourcesEtpKrLabel => 'KR';

  @override
  String get dataSourcesEtpKrValue => 'Naver Finance, KRX';

  @override
  String get dataSourcesEtpUsLabel => 'US';

  @override
  String get dataSourcesEtpUsValue => 'Nasdaq, Yahoo Finance';

  @override
  String get dataSourcesNotice =>
      'Roll-adjusted values are computed by this app from S&P GSCI and Bloomberg index methodologies. For personal reference only; accuracy not guaranteed; not investment advice.';

  @override
  String get alertSettingsTitle => 'Alert settings';

  @override
  String get alertSettingsCommodity => 'Target commodity';

  @override
  String get alertSettingsCommodityNone => 'None';

  @override
  String get alertSettingsCriteria => 'Current criteria';

  @override
  String alertSettingsCriteriaChart(String basis, int maPeriod, String window) {
    return 'Basis $basis · $maPeriod-day MA · $window';
  }

  @override
  String alertSettingsCriteriaWindowYears(String years) {
    return '$years years';
  }

  @override
  String alertSettingsCriteriaLevels(String levels) {
    return 'Levels $levels% (above & below)';
  }

  @override
  String get alertSettingsQuietTime => 'Quiet hours';

  @override
  String get alertSettingsQuietStart => 'Start';

  @override
  String get alertSettingsQuietEnd => 'End';

  @override
  String alertSettingsQuietNextDay(String time) {
    return 'next day $time';
  }

  @override
  String get alertSettingsQuietNote =>
      'Alerts during quiet hours are sent at the end time, only the rarest one per direction.';

  @override
  String get alertSettingsGuide =>
      'Checked every 15 minutes during trading hours; each level alerts at most once per CME trading day. You are alerted when today\'s candle wick touches a rare-level line on the chart (intraday touches, so alerts can fire more often than p%).';
}
