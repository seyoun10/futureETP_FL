import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 2단계 임시 dev 화면 제목. 3단계 B-b·A 화면이 생기면 지운다
  ///
  /// In ko, this message translates to:
  /// **'서버 연결 확인'**
  String get devHealthTitle;

  /// 4단계 C-a 차트 스파이크 dev 화면. 스파이크가 끝나면 지운다
  ///
  /// In ko, this message translates to:
  /// **'차트 스파이크'**
  String get devChartSpikeTitle;

  /// No description provided for @devChartSpikeStats.
  ///
  /// In ko, this message translates to:
  /// **'{fps}fps · 최악 {worst}ms · 봉 {bars}개'**
  String devChartSpikeStats(int fps, String worst, int bars);

  /// No description provided for @devHealthVariant.
  ///
  /// In ko, this message translates to:
  /// **'변형: {variant}'**
  String devHealthVariant(String variant);

  /// No description provided for @devHealthServer.
  ///
  /// In ko, this message translates to:
  /// **'서버: {url}'**
  String devHealthServer(String url);

  /// No description provided for @devHealthOk.
  ///
  /// In ko, this message translates to:
  /// **'연결됨 (status {status}, commit {commit})'**
  String devHealthOk(String status, String commit);

  /// No description provided for @devHealthFailed.
  ///
  /// In ko, this message translates to:
  /// **'연결 실패: {error}'**
  String devHealthFailed(String error);

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @accessKeyTitle.
  ///
  /// In ko, this message translates to:
  /// **'접근 키'**
  String get accessKeyTitle;

  /// No description provided for @accessKeyGuide.
  ///
  /// In ko, this message translates to:
  /// **'서버 접근 키를 넣어 주세요. Mac에서 키 스크립트가 띄운 QR을 읽거나 키를 붙여넣으세요.'**
  String get accessKeyGuide;

  /// No description provided for @accessKeyPastePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'키 붙여넣기'**
  String get accessKeyPastePlaceholder;

  /// No description provided for @accessKeySubmit.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get accessKeySubmit;

  /// No description provided for @accessKeyVerifying.
  ///
  /// In ko, this message translates to:
  /// **'확인 중'**
  String get accessKeyVerifying;

  /// No description provided for @accessKeyBadFormat.
  ///
  /// In ko, this message translates to:
  /// **'키 형식이 맞지 않습니다.'**
  String get accessKeyBadFormat;

  /// No description provided for @accessKeyRejected.
  ///
  /// In ko, this message translates to:
  /// **'키가 맞지 않습니다.'**
  String get accessKeyRejected;

  /// No description provided for @accessKeyScanQr.
  ///
  /// In ko, this message translates to:
  /// **'QR 읽기'**
  String get accessKeyScanQr;

  /// No description provided for @accessKeyScannerLabel.
  ///
  /// In ko, this message translates to:
  /// **'QR 카메라'**
  String get accessKeyScannerLabel;

  /// No description provided for @accessKeyNotKeyQr.
  ///
  /// In ko, this message translates to:
  /// **'접근 키 QR이 아닙니다.'**
  String get accessKeyNotKeyQr;

  /// No description provided for @accessKeyCameraUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'카메라를 쓸 수 없습니다. 키를 붙여넣어 주세요.'**
  String get accessKeyCameraUnavailable;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ko, this message translates to:
  /// **'접근 키가 없거나 맞지 않습니다.'**
  String get errorUnauthorized;

  /// No description provided for @errorRateLimited.
  ///
  /// In ko, this message translates to:
  /// **'요청이 너무 많습니다. 잠시 뒤 다시 시도해 주세요.'**
  String get errorRateLimited;

  /// No description provided for @errorValidationFailed.
  ///
  /// In ko, this message translates to:
  /// **'입력값이 올바르지 않습니다.'**
  String get errorValidationFailed;

  /// No description provided for @errorNotFound.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 찾을 수 없습니다.'**
  String get errorNotFound;

  /// No description provided for @errorInternal.
  ///
  /// In ko, this message translates to:
  /// **'서버에 문제가 생겼습니다. 잠시 뒤 다시 시도해 주세요.'**
  String get errorInternal;

  /// No description provided for @errorNetwork.
  ///
  /// In ko, this message translates to:
  /// **'네트워크에 연결할 수 없습니다.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In ko, this message translates to:
  /// **'서버 응답이 늦습니다. 잠시 뒤 다시 시도해 주세요.'**
  String get errorTimeout;

  /// No description provided for @errorSchemaMismatch.
  ///
  /// In ko, this message translates to:
  /// **'앱과 서버 버전이 맞지 않습니다. 앱을 업데이트해 주세요.'**
  String get errorSchemaMismatch;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'불러오는 중'**
  String get loading;

  /// No description provided for @freshnessAsOf.
  ///
  /// In ko, this message translates to:
  /// **'{time} 기준'**
  String freshnessAsOf(String time);

  /// No description provided for @freshnessTradeDate.
  ///
  /// In ko, this message translates to:
  /// **'거래일 {date}'**
  String freshnessTradeDate(String date);

  /// No description provided for @freshnessDelayed.
  ///
  /// In ko, this message translates to:
  /// **'지연'**
  String get freshnessDelayed;

  /// No description provided for @marketStateOpen.
  ///
  /// In ko, this message translates to:
  /// **'장중'**
  String get marketStateOpen;

  /// No description provided for @marketStateClosed.
  ///
  /// In ko, this message translates to:
  /// **'휴장'**
  String get marketStateClosed;

  /// No description provided for @marketStateSettlementPending.
  ///
  /// In ko, this message translates to:
  /// **'정산 대기'**
  String get marketStateSettlementPending;

  /// No description provided for @back.
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get back;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// 원자재 이름. 원자재가 늘면 여기에 더한다
  ///
  /// In ko, this message translates to:
  /// **'{code, select, GC{금} SI{은} CL{원유} NG{천연가스} other{{code}}}'**
  String commodityName(String code);

  /// No description provided for @commodityListAlert.
  ///
  /// In ko, this message translates to:
  /// **'알림 대상'**
  String get commodityListAlert;

  /// No description provided for @commodityListNoTrade.
  ///
  /// In ko, this message translates to:
  /// **'거래 없음'**
  String get commodityListNoTrade;

  /// No description provided for @commodityListRefreshFailedTitle.
  ///
  /// In ko, this message translates to:
  /// **'새로고침을 마치지 못했습니다'**
  String get commodityListRefreshFailedTitle;

  /// No description provided for @commodityListRefreshFailedMessage.
  ///
  /// In ko, this message translates to:
  /// **'잠시 뒤 다시 당겨 주세요.'**
  String get commodityListRefreshFailedMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @settingsAlertOffBadge.
  ///
  /// In ko, this message translates to:
  /// **'알림 꺼짐'**
  String get settingsAlertOffBadge;

  /// No description provided for @commodityRotate.
  ///
  /// In ko, this message translates to:
  /// **'가로/세로 전환'**
  String get commodityRotate;

  /// No description provided for @commodityTabDisparity.
  ///
  /// In ko, this message translates to:
  /// **'이격도차트'**
  String get commodityTabDisparity;

  /// No description provided for @commodityTabContracts.
  ///
  /// In ko, this message translates to:
  /// **'월물차트'**
  String get commodityTabContracts;

  /// No description provided for @commodityTabCurve.
  ///
  /// In ko, this message translates to:
  /// **'월물커브'**
  String get commodityTabCurve;

  /// No description provided for @commodityTabEtps.
  ///
  /// In ko, this message translates to:
  /// **'ETP'**
  String get commodityTabEtps;

  /// No description provided for @basisFront.
  ///
  /// In ko, this message translates to:
  /// **'대표월물'**
  String get basisFront;

  /// No description provided for @basisKr.
  ///
  /// In ko, this message translates to:
  /// **'한국형'**
  String get basisKr;

  /// No description provided for @basisUs.
  ///
  /// In ko, this message translates to:
  /// **'미국형'**
  String get basisUs;

  /// No description provided for @chartMonth.
  ///
  /// In ko, this message translates to:
  /// **'{month, select, 1{1월} 2{2월} 3{3월} 4{4월} 5{5월} 6{6월} 7{7월} 8{8월} 9{9월} 10{10월} 11{11월} 12{12월} other{{month}}}'**
  String chartMonth(String month);

  /// No description provided for @chartHighTag.
  ///
  /// In ko, this message translates to:
  /// **'고가 {price}({pct}, {date})'**
  String chartHighTag(String price, String pct, String date);

  /// No description provided for @chartLowTag.
  ///
  /// In ko, this message translates to:
  /// **'저가 {price}({pct}, {date})'**
  String chartLowTag(String price, String pct, String date);

  /// No description provided for @chartPeriodsLabel.
  ///
  /// In ko, this message translates to:
  /// **'기간'**
  String get chartPeriodsLabel;

  /// No description provided for @chartResetView.
  ///
  /// In ko, this message translates to:
  /// **'선택한 기간의 최근 위치로'**
  String get chartResetView;

  /// No description provided for @chartOlderFailedTitle.
  ///
  /// In ko, this message translates to:
  /// **'과거 데이터를 불러오지 못했습니다'**
  String get chartOlderFailedTitle;

  /// No description provided for @chartOlderFailedMessage.
  ///
  /// In ko, this message translates to:
  /// **'잠시 뒤 차트를 다시 끌어 주세요.'**
  String get chartOlderFailedMessage;

  /// No description provided for @disparityBasisFallback.
  ///
  /// In ko, this message translates to:
  /// **'{basis}*'**
  String disparityBasisFallback(String basis);

  /// No description provided for @disparityBasisInRoll.
  ///
  /// In ko, this message translates to:
  /// **'{basis} (롤 중)'**
  String disparityBasisInRoll(String basis);

  /// No description provided for @disparityOpen.
  ///
  /// In ko, this message translates to:
  /// **'시'**
  String get disparityOpen;

  /// No description provided for @disparityHigh.
  ///
  /// In ko, this message translates to:
  /// **'고'**
  String get disparityHigh;

  /// No description provided for @disparityLow.
  ///
  /// In ko, this message translates to:
  /// **'저'**
  String get disparityLow;

  /// No description provided for @disparityClose.
  ///
  /// In ko, this message translates to:
  /// **'종'**
  String get disparityClose;

  /// No description provided for @disparityValue.
  ///
  /// In ko, this message translates to:
  /// **'이격도 {value}'**
  String disparityValue(String value);

  /// No description provided for @disparityTailUp.
  ///
  /// In ko, this message translates to:
  /// **'상위 {pct}%'**
  String disparityTailUp(String pct);

  /// No description provided for @disparityTailDown.
  ///
  /// In ko, this message translates to:
  /// **'하위 {pct}%'**
  String disparityTailDown(String pct);

  /// No description provided for @disparityFromLow.
  ///
  /// In ko, this message translates to:
  /// **'저점대비 {pct}'**
  String disparityFromLow(String pct);

  /// No description provided for @disparityFromHigh.
  ///
  /// In ko, this message translates to:
  /// **'고점대비 {pct}'**
  String disparityFromHigh(String pct);

  /// No description provided for @disparityPrevChange.
  ///
  /// In ko, this message translates to:
  /// **'전일 대비'**
  String get disparityPrevChange;

  /// No description provided for @disparityLabel.
  ///
  /// In ko, this message translates to:
  /// **'이격도'**
  String get disparityLabel;

  /// No description provided for @disparityMa.
  ///
  /// In ko, this message translates to:
  /// **'{n}일선'**
  String disparityMa(String n);

  /// No description provided for @disparityNoData.
  ///
  /// In ko, this message translates to:
  /// **'표시할 봉이 없습니다.'**
  String get disparityNoData;

  /// No description provided for @disparityHintFront.
  ///
  /// In ko, this message translates to:
  /// **'대표월물: 거래량이 가장 많은 월물의 실제 가격입니다. 월물이 바뀌는 날 가격이 건너뜁니다.'**
  String get disparityHintFront;

  /// No description provided for @disparityHintAdjusted.
  ///
  /// In ko, this message translates to:
  /// **'{basis}: 롤 규칙대로 월물을 갈아탄 수익률을 이어 붙인 조정 가격입니다. 실제 월물 가격과 다릅니다.'**
  String disparityHintAdjusted(String basis);

  /// No description provided for @disparityHintFallback.
  ///
  /// In ko, this message translates to:
  /// **'이 원자재에는 {basis} 상품이 없어 대표월물로 대신 보여 줍니다.'**
  String disparityHintFallback(String basis);

  /// No description provided for @disparityHintSameAsKr.
  ///
  /// In ko, this message translates to:
  /// **'금·은은 미국형이 한국형과 같습니다.'**
  String get disparityHintSameAsKr;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
