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
