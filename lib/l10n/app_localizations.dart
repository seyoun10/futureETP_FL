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

  /// No description provided for @contractsProvisional.
  ///
  /// In ko, this message translates to:
  /// **'(잠정)'**
  String get contractsProvisional;

  /// No description provided for @contractsRollYield.
  ///
  /// In ko, this message translates to:
  /// **'롤 수익률'**
  String get contractsRollYield;

  /// No description provided for @contractsNoData.
  ///
  /// In ko, this message translates to:
  /// **'표시할 월물이 없습니다.'**
  String get contractsNoData;

  /// 연환산 롤 수익률(C-b·C-c). pct는 formatChangePct 결과
  ///
  /// In ko, this message translates to:
  /// **'{pct}/년'**
  String chartPerYear(String pct);

  /// No description provided for @curvePrev.
  ///
  /// In ko, this message translates to:
  /// **'기준일을 1 거래일 앞으로'**
  String get curvePrev;

  /// No description provided for @curveNext.
  ///
  /// In ko, this message translates to:
  /// **'기준일을 1 거래일 뒤로'**
  String get curveNext;

  /// No description provided for @curveReset.
  ///
  /// In ko, this message translates to:
  /// **'기준일을 최근 거래일로'**
  String get curveReset;

  /// No description provided for @curveRollYield.
  ///
  /// In ko, this message translates to:
  /// **'롤 수익률 {value}'**
  String curveRollYield(String value);

  /// No description provided for @curveUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'산출 불가'**
  String get curveUnavailable;

  /// No description provided for @curveTooltipChange.
  ///
  /// In ko, this message translates to:
  /// **'변화율'**
  String get curveTooltipChange;

  /// No description provided for @curveNoData.
  ///
  /// In ko, this message translates to:
  /// **'표시할 월물이 없습니다.'**
  String get curveNoData;

  /// No description provided for @curvePickTitle.
  ///
  /// In ko, this message translates to:
  /// **'기준일 선택'**
  String get curvePickTitle;

  /// No description provided for @curvePickRange.
  ///
  /// In ko, this message translates to:
  /// **'선택 가능: {min} ~ {max}'**
  String curvePickRange(String min, String max);

  /// 휴장일을 골라 서버가 옮긴 기준일 안내(C-b)
  ///
  /// In ko, this message translates to:
  /// **'휴장일이라 {date}({weekday})로 옮겼습니다'**
  String curveMoved(String date, String weekday);

  /// No description provided for @etpMarket.
  ///
  /// In ko, this message translates to:
  /// **'시장'**
  String get etpMarket;

  /// No description provided for @etpType.
  ///
  /// In ko, this message translates to:
  /// **'유형'**
  String get etpType;

  /// No description provided for @etpLeverage.
  ///
  /// In ko, this message translates to:
  /// **'배수'**
  String get etpLeverage;

  /// No description provided for @etpFxHedge.
  ///
  /// In ko, this message translates to:
  /// **'환헤지'**
  String get etpFxHedge;

  /// No description provided for @etpSort.
  ///
  /// In ko, this message translates to:
  /// **'정렬'**
  String get etpSort;

  /// No description provided for @etpAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get etpAll;

  /// No description provided for @etpLeverageValue.
  ///
  /// In ko, this message translates to:
  /// **'{n}x'**
  String etpLeverageValue(String n);

  /// No description provided for @etpFxHedged.
  ///
  /// In ko, this message translates to:
  /// **'환헤지'**
  String get etpFxHedged;

  /// No description provided for @etpFxUnhedged.
  ///
  /// In ko, this message translates to:
  /// **'환노출'**
  String get etpFxUnhedged;

  /// No description provided for @etpFxNa.
  ///
  /// In ko, this message translates to:
  /// **'해당 없음'**
  String get etpFxNa;

  /// No description provided for @etpSortDefault.
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get etpSortDefault;

  /// No description provided for @etpSortAum.
  ///
  /// In ko, this message translates to:
  /// **'순자산'**
  String get etpSortAum;

  /// No description provided for @etpSortTradingValue.
  ///
  /// In ko, this message translates to:
  /// **'거래대금'**
  String get etpSortTradingValue;

  /// No description provided for @etpSortValue.
  ///
  /// In ko, this message translates to:
  /// **'{label} {amount}'**
  String etpSortValue(String label, String amount);

  /// No description provided for @etpNoValue.
  ///
  /// In ko, this message translates to:
  /// **'—'**
  String get etpNoValue;

  /// 원화 금액 줄임 방식(AmountScheme 이름 eok·si). 달러는 언어와 상관없이 si다
  ///
  /// In ko, this message translates to:
  /// **'eok'**
  String get etpKrwScheme;

  /// No description provided for @etpAmountKrx.
  ///
  /// In ko, this message translates to:
  /// **'{n} 원'**
  String etpAmountKrx(String n);

  /// No description provided for @etpAmountUs.
  ///
  /// In ko, this message translates to:
  /// **'\${n}'**
  String etpAmountUs(String n);

  /// No description provided for @etpEmpty.
  ///
  /// In ko, this message translates to:
  /// **'이 원자재의 ETP가 없습니다.'**
  String get etpEmpty;

  /// No description provided for @etpNoMatch.
  ///
  /// In ko, this message translates to:
  /// **'조건에 맞는 상품이 없습니다.'**
  String get etpNoMatch;

  /// No description provided for @etpDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'ETP 상세'**
  String get etpDetailTitle;

  /// No description provided for @etpCommodity.
  ///
  /// In ko, this message translates to:
  /// **'원자재'**
  String get etpCommodity;

  /// No description provided for @etpIssuer.
  ///
  /// In ko, this message translates to:
  /// **'운용사'**
  String get etpIssuer;

  /// No description provided for @etpUnderlyingIndex.
  ///
  /// In ko, this message translates to:
  /// **'기초지수'**
  String get etpUnderlyingIndex;

  /// No description provided for @etpExpenseRatio.
  ///
  /// In ko, this message translates to:
  /// **'총보수'**
  String get etpExpenseRatio;

  /// No description provided for @etpExpenseRatioValue.
  ///
  /// In ko, this message translates to:
  /// **'{n}%'**
  String etpExpenseRatioValue(String n);

  /// No description provided for @etpListedDate.
  ///
  /// In ko, this message translates to:
  /// **'상장일'**
  String get etpListedDate;

  /// No description provided for @etpTicker.
  ///
  /// In ko, this message translates to:
  /// **'종목코드'**
  String get etpTicker;

  /// No description provided for @etpSeriesCode.
  ///
  /// In ko, this message translates to:
  /// **'{code} 시리즈'**
  String etpSeriesCode(String code);

  /// No description provided for @etpMaturity.
  ///
  /// In ko, this message translates to:
  /// **'만기 {date}'**
  String etpMaturity(String date);

  /// No description provided for @etpOpenIssuer.
  ///
  /// In ko, this message translates to:
  /// **'운용사 페이지 열기 ↗'**
  String get etpOpenIssuer;

  /// No description provided for @etpSourceNote.
  ///
  /// In ko, this message translates to:
  /// **'자동 수집 정보 · 원문 언어로 표시'**
  String get etpSourceNote;

  /// No description provided for @done.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get done;

  /// No description provided for @settingsReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get settingsReset;

  /// No description provided for @settingsResetTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정 초기화'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetMessage.
  ///
  /// In ko, this message translates to:
  /// **'표시·이격도차트 설정을 기본값으로 되돌릴까요? 알림 설정과 접근 키는 그대로입니다.'**
  String get settingsResetMessage;

  /// No description provided for @settingsAlerts.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get settingsAlerts;

  /// No description provided for @settingsAccessKey.
  ///
  /// In ko, this message translates to:
  /// **'접근 키'**
  String get settingsAccessKey;

  /// No description provided for @settingsAccessKeySaved.
  ///
  /// In ko, this message translates to:
  /// **'설정됨'**
  String get settingsAccessKeySaved;

  /// No description provided for @settingsDataSources.
  ///
  /// In ko, this message translates to:
  /// **'데이터 출처'**
  String get settingsDataSources;

  /// No description provided for @settingsLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// No description provided for @settingsUpDownStyle.
  ///
  /// In ko, this message translates to:
  /// **'등락 색'**
  String get settingsUpDownStyle;

  /// No description provided for @settingsUpDownStyleKr.
  ///
  /// In ko, this message translates to:
  /// **'한국식'**
  String get settingsUpDownStyleKr;

  /// No description provided for @settingsUpDownStyleUs.
  ///
  /// In ko, this message translates to:
  /// **'미국식'**
  String get settingsUpDownStyleUs;

  /// 언어 이름은 그 언어로 쓴다
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get settingsLanguageKo;

  /// 언어 이름은 그 언어로 쓴다
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsSectionDisparity.
  ///
  /// In ko, this message translates to:
  /// **'이격도차트'**
  String get settingsSectionDisparity;

  /// No description provided for @settingsSectionOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get settingsSectionOther;

  /// No description provided for @settingsBasis.
  ///
  /// In ko, this message translates to:
  /// **'차트 기준값'**
  String get settingsBasis;

  /// No description provided for @settingsMaPeriod.
  ///
  /// In ko, this message translates to:
  /// **'기준 이평선(일)'**
  String get settingsMaPeriod;

  /// No description provided for @settingsWindow.
  ///
  /// In ko, this message translates to:
  /// **'분포 기간(년)'**
  String get settingsWindow;

  /// No description provided for @settingsWindowAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get settingsWindowAll;

  /// No description provided for @settingsAlertOff.
  ///
  /// In ko, this message translates to:
  /// **'끔'**
  String get settingsAlertOff;

  /// No description provided for @settingsRareLevels.
  ///
  /// In ko, this message translates to:
  /// **'rare-level(%)'**
  String get settingsRareLevels;

  /// No description provided for @settingsRareLevelField.
  ///
  /// In ko, this message translates to:
  /// **'rare-level {index}'**
  String settingsRareLevelField(int index);

  /// No description provided for @settingsRareLevelHint.
  ///
  /// In ko, this message translates to:
  /// **'{min}~{max}, 소수 첫째 자리, 서로 다른 {count}개'**
  String settingsRareLevelHint(String min, String max, int count);

  /// No description provided for @settingsRareLevelInvalid.
  ///
  /// In ko, this message translates to:
  /// **'{min}~{max} 사이 값을 소수 첫째 자리까지 입력해 주세요.'**
  String settingsRareLevelInvalid(String min, String max);

  /// No description provided for @settingsRareLevelDuplicate.
  ///
  /// In ko, this message translates to:
  /// **'서로 다른 값 {count}개를 입력해 주세요.'**
  String settingsRareLevelDuplicate(int count);

  /// No description provided for @settingsSaveFailed.
  ///
  /// In ko, this message translates to:
  /// **'저장하지 못했습니다. {reason}'**
  String settingsSaveFailed(String reason);

  /// No description provided for @settingsLanguageDesc.
  ///
  /// In ko, this message translates to:
  /// **'화면과 푸시 알림 문구의 언어'**
  String get settingsLanguageDesc;

  /// No description provided for @settingsUpDownStyleDesc.
  ///
  /// In ko, this message translates to:
  /// **'한국식은 상승 빨강·하락 파랑, 미국식은 상승 초록·하락 빨강'**
  String get settingsUpDownStyleDesc;

  /// No description provided for @settingsBasisDesc.
  ///
  /// In ko, this message translates to:
  /// **'차트와 알림에 쓰는 월물. 대표월물은 거래량이 가장 많은 월물, 한국형·미국형은 국내·미국 ETP의 롤 규칙'**
  String get settingsBasisDesc;

  /// No description provided for @settingsMaPeriodDesc.
  ///
  /// In ko, this message translates to:
  /// **'이격도를 재는 기준 이동평균 기간'**
  String get settingsMaPeriodDesc;

  /// No description provided for @settingsWindowDesc.
  ///
  /// In ko, this message translates to:
  /// **'드문 정도를 판단할 과거 이격도 기간'**
  String get settingsWindowDesc;

  /// No description provided for @settingsRareLevelsDesc.
  ///
  /// In ko, this message translates to:
  /// **'과거 이격도의 위·아래 끝 몇 %를 차트 밴드로 그리고, 닿으면 알림을 보냅니다'**
  String get settingsRareLevelsDesc;

  /// No description provided for @settingsAlertsDesc.
  ///
  /// In ko, this message translates to:
  /// **'rare-level 도달 알림을 받을 원자재와 알림 거부 시간'**
  String get settingsAlertsDesc;

  /// No description provided for @settingsAccessKeyDesc.
  ///
  /// In ko, this message translates to:
  /// **'서버에 접속하는 비밀 키'**
  String get settingsAccessKeyDesc;

  /// No description provided for @settingsDataSourcesDesc.
  ///
  /// In ko, this message translates to:
  /// **'시세와 데이터를 가져오는 곳'**
  String get settingsDataSourcesDesc;

  /// B 최하단 줄. OTA가 없어 RN 앱 번들 줄 대신 설치한 빌드를 보인다(FL-031)
  ///
  /// In ko, this message translates to:
  /// **'앱 버전: {version} (빌드 {build}) · {variant}'**
  String settingsAppVersion(String version, String build, String variant);

  /// No description provided for @dataSourcesFutures.
  ///
  /// In ko, this message translates to:
  /// **'선물 시세'**
  String get dataSourcesFutures;

  /// No description provided for @dataSourcesEtp.
  ///
  /// In ko, this message translates to:
  /// **'ETP'**
  String get dataSourcesEtp;

  /// No description provided for @dataSourcesExchangeLabel.
  ///
  /// In ko, this message translates to:
  /// **'거래소'**
  String get dataSourcesExchangeLabel;

  /// No description provided for @dataSourcesExchangeValue.
  ///
  /// In ko, this message translates to:
  /// **'CME Group (NYMEX·COMEX)'**
  String get dataSourcesExchangeValue;

  /// No description provided for @dataSourcesSettlementLabel.
  ///
  /// In ko, this message translates to:
  /// **'정산가·거래량'**
  String get dataSourcesSettlementLabel;

  /// No description provided for @dataSourcesSettlementValue.
  ///
  /// In ko, this message translates to:
  /// **'Massive · 장 마감 후 반영'**
  String get dataSourcesSettlementValue;

  /// No description provided for @dataSourcesIntradayLabel.
  ///
  /// In ko, this message translates to:
  /// **'장중 시세'**
  String get dataSourcesIntradayLabel;

  /// No description provided for @dataSourcesIntradayValue.
  ///
  /// In ko, this message translates to:
  /// **'Yahoo Finance · 약 10분 지연'**
  String get dataSourcesIntradayValue;

  /// No description provided for @dataSourcesHistoryLabel.
  ///
  /// In ko, this message translates to:
  /// **'과거 일봉'**
  String get dataSourcesHistoryLabel;

  /// No description provided for @dataSourcesHistoryValue.
  ///
  /// In ko, this message translates to:
  /// **'Databento (2010-06~)'**
  String get dataSourcesHistoryValue;

  /// No description provided for @dataSourcesEtpKrLabel.
  ///
  /// In ko, this message translates to:
  /// **'국내'**
  String get dataSourcesEtpKrLabel;

  /// No description provided for @dataSourcesEtpKrValue.
  ///
  /// In ko, this message translates to:
  /// **'네이버 증권, KRX'**
  String get dataSourcesEtpKrValue;

  /// No description provided for @dataSourcesEtpUsLabel.
  ///
  /// In ko, this message translates to:
  /// **'미국'**
  String get dataSourcesEtpUsLabel;

  /// No description provided for @dataSourcesEtpUsValue.
  ///
  /// In ko, this message translates to:
  /// **'Nasdaq, Yahoo Finance'**
  String get dataSourcesEtpUsValue;

  /// No description provided for @dataSourcesNotice.
  ///
  /// In ko, this message translates to:
  /// **'롤 규칙: S&P GSCI·Bloomberg 지수 방법론을 따라 앱이 계산한 값입니다. 개인 참고용이며 정확성을 보장하지 않고, 투자 권유가 아닙니다.'**
  String get dataSourcesNotice;

  /// No description provided for @alertSettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get alertSettingsTitle;

  /// No description provided for @alertSettingsPermissionOff.
  ///
  /// In ko, this message translates to:
  /// **'⚠ 알림 권한이 꺼져 있습니다'**
  String get alertSettingsPermissionOff;

  /// No description provided for @alertSettingsPermissionAllow.
  ///
  /// In ko, this message translates to:
  /// **'허용'**
  String get alertSettingsPermissionAllow;

  /// No description provided for @alertSettingsPermissionOpenSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정 열기'**
  String get alertSettingsPermissionOpenSettings;

  /// No description provided for @alertSettingsCommodity.
  ///
  /// In ko, this message translates to:
  /// **'대상 원자재'**
  String get alertSettingsCommodity;

  /// No description provided for @alertSettingsCommodityNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get alertSettingsCommodityNone;

  /// No description provided for @alertSettingsCriteria.
  ///
  /// In ko, this message translates to:
  /// **'현재 적용 기준'**
  String get alertSettingsCriteria;

  /// No description provided for @alertSettingsCriteriaChart.
  ///
  /// In ko, this message translates to:
  /// **'기준값 {basis} · {maPeriod}일선 · {window}'**
  String alertSettingsCriteriaChart(String basis, int maPeriod, String window);

  /// No description provided for @alertSettingsCriteriaWindowYears.
  ///
  /// In ko, this message translates to:
  /// **'{years}년'**
  String alertSettingsCriteriaWindowYears(String years);

  /// No description provided for @alertSettingsCriteriaLevels.
  ///
  /// In ko, this message translates to:
  /// **'레벨 {levels}% (위·아래)'**
  String alertSettingsCriteriaLevels(String levels);

  /// No description provided for @alertSettingsQuietTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 거부 시간'**
  String get alertSettingsQuietTime;

  /// No description provided for @alertSettingsQuietStart.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get alertSettingsQuietStart;

  /// No description provided for @alertSettingsQuietEnd.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get alertSettingsQuietEnd;

  /// No description provided for @alertSettingsQuietNextDay.
  ///
  /// In ko, this message translates to:
  /// **'다음 날 {time}'**
  String alertSettingsQuietNextDay(String time);

  /// No description provided for @alertSettingsQuietNote.
  ///
  /// In ko, this message translates to:
  /// **'이 시간에 생긴 알림은 종료 시각에 방향별로 가장 드문 1건만 보냅니다.'**
  String get alertSettingsQuietNote;

  /// No description provided for @alertSettingsGuide.
  ///
  /// In ko, this message translates to:
  /// **'장중 15분마다 확인하며 레벨별로 CME 거래일당 1회 알려 드립니다. 차트의 rare-level 선에 오늘 봉의 꼬리가 닿으면 알립니다(장중 터치 기준이라 p%보다 자주 울릴 수 있음).'**
  String get alertSettingsGuide;

  /// Android 알림 채널 이름(OS 알림 설정에 보임, D-045)
  ///
  /// In ko, this message translates to:
  /// **'시세 알림'**
  String get pushChannelAlerts;

  /// No description provided for @pushChannelOps.
  ///
  /// In ko, this message translates to:
  /// **'운영 알림'**
  String get pushChannelOps;

  /// A-a 제목(D-143)
  ///
  /// In ko, this message translates to:
  /// **'휴장 달력'**
  String get calendarTitle;

  /// A title-bar [📅] 스크린 리더 이름
  ///
  /// In ko, this message translates to:
  /// **'휴장 달력'**
  String get calendarOpen;

  /// No description provided for @calendarMonthTitle.
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}'**
  String calendarMonthTitle(String year, String month);

  /// 달 이름. month는 1~12
  ///
  /// In ko, this message translates to:
  /// **'{month, select, 1{1월} 2{2월} 3{3월} 4{4월} 5{5월} 6{6월} 7{7월} 8{8월} 9{9월} 10{10월} 11{11월} 12{12월} other{{month}월}}'**
  String calendarMonthName(String month);

  /// 요일 약칭
  ///
  /// In ko, this message translates to:
  /// **'{day, select, sun{일} mon{월} tue{화} wed{수} thu{목} fri{금} sat{토} other{}}'**
  String calendarWeekday(String day);

  /// 시장 이름
  ///
  /// In ko, this message translates to:
  /// **'{market, select, CME{CME} KRX{KRX} NYSE{NYSE} other{{market}}}'**
  String calendarMarket(String market);

  /// 예외 종류. time은 기기 로컬 HH:mm(D-144)
  ///
  /// In ko, this message translates to:
  /// **'{kind, select, CLOSED{휴장} HALT{휴장 ({time} 거래 중단)} EARLY_CLOSE{조기 마감 {time}} LATE_OPEN{개장 지연 {time}} other{}}'**
  String calendarKind(String kind, String time);

  /// No description provided for @calendarLegendToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get calendarLegendToday;

  /// No description provided for @calendarLegendClosed.
  ///
  /// In ko, this message translates to:
  /// **'휴장'**
  String get calendarLegendClosed;

  /// No description provided for @calendarLegendShortened.
  ///
  /// In ko, this message translates to:
  /// **'조기 마감·개장 지연'**
  String get calendarLegendShortened;

  /// No description provided for @calendarListDate.
  ///
  /// In ko, this message translates to:
  /// **'{date} ({weekday})'**
  String calendarListDate(String date, String weekday);

  /// No description provided for @calendarNone.
  ///
  /// In ko, this message translates to:
  /// **'휴장·단축 거래 없음'**
  String get calendarNone;

  /// No description provided for @calendarMissing.
  ///
  /// In ko, this message translates to:
  /// **'{market} {year}년 휴장 정보가 아직 없습니다'**
  String calendarMissing(String market, String year);

  /// 날짜 칸 스크린 리더 문구 앞부분
  ///
  /// In ko, this message translates to:
  /// **'{month} {day}일'**
  String calendarCellDate(String month, String day);
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
