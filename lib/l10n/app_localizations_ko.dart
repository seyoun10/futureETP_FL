// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get retry => '다시 시도';

  @override
  String get accessKeyTitle => '접근 키';

  @override
  String get accessKeyGuide =>
      '서버 접근 키를 넣어 주세요. Mac에서 키 스크립트가 띄운 QR을 읽거나 키를 붙여넣으세요.';

  @override
  String get accessKeyPastePlaceholder => '키 붙여넣기';

  @override
  String get accessKeySubmit => '확인';

  @override
  String get accessKeyVerifying => '확인 중';

  @override
  String get accessKeyBadFormat => '키 형식이 맞지 않습니다.';

  @override
  String get accessKeyRejected => '키가 맞지 않습니다.';

  @override
  String get accessKeyScanQr => 'QR 읽기';

  @override
  String get accessKeyScannerLabel => 'QR 카메라';

  @override
  String get accessKeyNotKeyQr => '접근 키 QR이 아닙니다.';

  @override
  String get accessKeyCameraUnavailable => '카메라를 쓸 수 없습니다. 키를 붙여넣어 주세요.';

  @override
  String get cancel => '취소';

  @override
  String get errorUnauthorized => '접근 키가 없거나 맞지 않습니다.';

  @override
  String get errorRateLimited => '요청이 너무 많습니다. 잠시 뒤 다시 시도해 주세요.';

  @override
  String get errorValidationFailed => '입력값이 올바르지 않습니다.';

  @override
  String get errorNotFound => '데이터를 찾을 수 없습니다.';

  @override
  String get errorInternal => '서버에 문제가 생겼습니다. 잠시 뒤 다시 시도해 주세요.';

  @override
  String get errorNetwork => '네트워크에 연결할 수 없습니다.';

  @override
  String get errorTimeout => '서버 응답이 늦습니다. 잠시 뒤 다시 시도해 주세요.';

  @override
  String get errorSchemaMismatch => '앱과 서버 버전이 맞지 않습니다. 앱을 업데이트해 주세요.';

  @override
  String get loading => '불러오는 중';

  @override
  String freshnessAsOf(String time) {
    return '$time 기준';
  }

  @override
  String freshnessTradeDate(String date) {
    return '거래일 $date';
  }

  @override
  String get freshnessDelayed => '지연';

  @override
  String get marketStateOpen => '장중';

  @override
  String get marketStateClosed => '휴장';

  @override
  String get marketStateSettlementPending => '정산 대기';

  @override
  String get back => '뒤로';

  @override
  String get confirm => '확인';

  @override
  String commodityName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'GC': '금',
      'SI': '은',
      'CL': '원유',
      'NG': '천연가스',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get commodityListAlert => '알림 대상';

  @override
  String get commodityListNoTrade => '거래 없음';

  @override
  String get commodityListRefreshFailedTitle => '새로고침을 마치지 못했습니다';

  @override
  String get commodityListRefreshFailedMessage => '잠시 뒤 다시 당겨 주세요.';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsAlertOffBadge => '알림 꺼짐';

  @override
  String get commodityRotate => '가로/세로 전환';

  @override
  String get commodityTabDisparity => '이격도차트';

  @override
  String get commodityTabContracts => '월물차트';

  @override
  String get commodityTabCurve => '월물커브';

  @override
  String get commodityTabEtps => 'ETP';

  @override
  String get basisFront => '대표월물';

  @override
  String get basisKr => '한국형';

  @override
  String get basisUs => '미국형';

  @override
  String chartMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': '1월',
      '2': '2월',
      '3': '3월',
      '4': '4월',
      '5': '5월',
      '6': '6월',
      '7': '7월',
      '8': '8월',
      '9': '9월',
      '10': '10월',
      '11': '11월',
      '12': '12월',
      'other': '$month',
    });
    return '$_temp0';
  }

  @override
  String chartHighTag(String price, String pct, String date) {
    return '고가 $price($pct, $date)';
  }

  @override
  String chartLowTag(String price, String pct, String date) {
    return '저가 $price($pct, $date)';
  }

  @override
  String get chartPeriodsLabel => '기간';

  @override
  String get chartResetView => '선택한 기간의 최근 위치로';

  @override
  String get chartOlderFailedTitle => '과거 데이터를 불러오지 못했습니다';

  @override
  String get chartOlderFailedMessage => '잠시 뒤 차트를 다시 끌어 주세요.';

  @override
  String disparityBasisFallback(String basis) {
    return '$basis*';
  }

  @override
  String disparityBasisInRoll(String basis) {
    return '$basis (롤 중)';
  }

  @override
  String get disparityOpen => '시';

  @override
  String get disparityHigh => '고';

  @override
  String get disparityLow => '저';

  @override
  String get disparityClose => '종';

  @override
  String disparityValue(String value) {
    return '이격도 $value';
  }

  @override
  String disparityTailUp(String pct) {
    return '상위 $pct%';
  }

  @override
  String disparityTailDown(String pct) {
    return '하위 $pct%';
  }

  @override
  String disparityFromLow(String pct) {
    return '저점대비 $pct';
  }

  @override
  String disparityFromHigh(String pct) {
    return '고점대비 $pct';
  }

  @override
  String get disparityPrevChange => '전일 대비';

  @override
  String get disparityLabel => '이격도';

  @override
  String disparityMa(String n) {
    return '$n일선';
  }

  @override
  String get disparityNoData => '표시할 봉이 없습니다.';

  @override
  String get disparityHintFront =>
      '대표월물: 거래량이 가장 많은 월물의 실제 가격입니다. 월물이 바뀌는 날 가격이 건너뜁니다.';

  @override
  String disparityHintAdjusted(String basis) {
    return '$basis: 롤 규칙대로 월물을 갈아탄 수익률을 이어 붙인 조정 가격입니다. 실제 월물 가격과 다릅니다.';
  }

  @override
  String disparityHintFallback(String basis) {
    return '이 원자재에는 $basis 상품이 없어 대표월물로 대신 보여 줍니다.';
  }

  @override
  String get disparityHintSameAsKr => '금·은은 미국형이 한국형과 같습니다.';

  @override
  String get contractsProvisional => '(잠정)';

  @override
  String get contractsRollYield => '롤 수익률';

  @override
  String get contractsNoData => '표시할 월물이 없습니다.';

  @override
  String chartPerYear(String pct) {
    return '$pct/년';
  }

  @override
  String get curvePrev => '기준일을 1 거래일 앞으로';

  @override
  String get curveNext => '기준일을 1 거래일 뒤로';

  @override
  String get curveReset => '기준일을 최근 거래일로';

  @override
  String curveRollYield(String value) {
    return '롤 수익률 $value';
  }

  @override
  String get curveUnavailable => '산출 불가';

  @override
  String get curveTooltipChange => '변화율';

  @override
  String get curveNoData => '표시할 월물이 없습니다.';

  @override
  String get curvePickTitle => '기준일 선택';

  @override
  String curvePickRange(String min, String max) {
    return '선택 가능: $min ~ $max';
  }

  @override
  String curveMoved(String date, String weekday) {
    return '휴장일이라 $date($weekday)로 옮겼습니다';
  }

  @override
  String get etpMarket => '시장';

  @override
  String get etpType => '유형';

  @override
  String get etpLeverage => '배수';

  @override
  String get etpFxHedge => '환헤지';

  @override
  String get etpSort => '정렬';

  @override
  String get etpAll => '전체';

  @override
  String etpLeverageValue(String n) {
    return '${n}x';
  }

  @override
  String get etpFxHedged => '환헤지';

  @override
  String get etpFxUnhedged => '환노출';

  @override
  String get etpFxNa => '해당 없음';

  @override
  String get etpSortDefault => '기본';

  @override
  String get etpSortAum => '순자산';

  @override
  String get etpSortTradingValue => '거래대금';

  @override
  String etpSortValue(String label, String amount) {
    return '$label $amount';
  }

  @override
  String get etpNoValue => '—';

  @override
  String get etpKrwScheme => 'eok';

  @override
  String etpAmountKrx(String n) {
    return '$n 원';
  }

  @override
  String etpAmountUs(String n) {
    return '\$$n';
  }

  @override
  String get etpEmpty => '이 원자재의 ETP가 없습니다.';

  @override
  String get etpNoMatch => '조건에 맞는 상품이 없습니다.';

  @override
  String get etpDetailTitle => 'ETP 상세';

  @override
  String get etpCommodity => '원자재';

  @override
  String get etpIssuer => '운용사';

  @override
  String get etpUnderlyingIndex => '기초지수';

  @override
  String get etpExpenseRatio => '총보수';

  @override
  String etpExpenseRatioValue(String n) {
    return '$n%';
  }

  @override
  String get etpListedDate => '상장일';

  @override
  String get etpTicker => '종목코드';

  @override
  String etpSeriesCode(String code) {
    return '$code 시리즈';
  }

  @override
  String etpMaturity(String date) {
    return '만기 $date';
  }

  @override
  String get etpOpenIssuer => '운용사 페이지 열기 ↗';

  @override
  String get etpSourceNote => '자동 수집 정보 · 원문 언어로 표시';

  @override
  String get done => '완료';

  @override
  String get settingsReset => '초기화';

  @override
  String get settingsResetTitle => '설정 초기화';

  @override
  String get settingsResetMessage =>
      '표시·이격도차트 설정을 기본값으로 되돌릴까요? 알림 설정과 접근 키는 그대로입니다.';

  @override
  String get settingsAlerts => '알림';

  @override
  String get settingsAccessKey => '접근 키';

  @override
  String get settingsAccessKeySaved => '설정됨';

  @override
  String get settingsDataSources => '데이터 출처';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsUpDownStyle => '등락 색';

  @override
  String get settingsUpDownStyleKr => '한국식';

  @override
  String get settingsUpDownStyleUs => '미국식';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSectionGeneral => '일반';

  @override
  String get settingsSectionDisparity => '이격도차트';

  @override
  String get settingsSectionOther => '기타';

  @override
  String get settingsBasis => '차트 기준값';

  @override
  String get settingsMaPeriod => '기준 이평선(일)';

  @override
  String get settingsWindow => '분포 기간(년)';

  @override
  String get settingsWindowAll => '전체';

  @override
  String get settingsAlertOff => '끔';

  @override
  String get settingsRareLevels => 'rare-level(%)';

  @override
  String settingsRareLevelField(int index) {
    return 'rare-level $index';
  }

  @override
  String settingsRareLevelHint(String min, String max, int count) {
    return '$min~$max, 소수 첫째 자리, 서로 다른 $count개';
  }

  @override
  String settingsRareLevelInvalid(String min, String max) {
    return '$min~$max 사이 값을 소수 첫째 자리까지 입력해 주세요.';
  }

  @override
  String settingsRareLevelDuplicate(int count) {
    return '서로 다른 값 $count개를 입력해 주세요.';
  }

  @override
  String settingsSaveFailed(String reason) {
    return '저장하지 못했습니다. $reason';
  }

  @override
  String get settingsLanguageDesc => '화면과 푸시 알림 문구의 언어';

  @override
  String get settingsUpDownStyleDesc => '한국식은 상승 빨강·하락 파랑, 미국식은 상승 초록·하락 빨강';

  @override
  String get settingsBasisDesc =>
      '차트와 알림에 쓰는 월물. 대표월물은 거래량이 가장 많은 월물, 한국형·미국형은 국내·미국 ETP의 롤 규칙';

  @override
  String get settingsMaPeriodDesc => '이격도를 재는 기준 이동평균 기간';

  @override
  String get settingsWindowDesc => '드문 정도를 판단할 과거 이격도 기간';

  @override
  String get settingsRareLevelsDesc =>
      '과거 이격도의 위·아래 끝 몇 %를 차트 밴드로 그리고, 닿으면 알림을 보냅니다';

  @override
  String get settingsAlertsDesc => 'rare-level 도달 알림을 받을 원자재와 알림 거부 시간';

  @override
  String get settingsAccessKeyDesc => '서버에 접속하는 비밀 키';

  @override
  String get settingsDataSourcesDesc => '시세와 데이터를 가져오는 곳';

  @override
  String settingsAppVersion(String version, String build, String variant) {
    return '앱 버전: $version (빌드 $build) · $variant';
  }

  @override
  String get dataSourcesFutures => '선물 시세';

  @override
  String get dataSourcesEtp => 'ETP';

  @override
  String get dataSourcesExchangeLabel => '거래소';

  @override
  String get dataSourcesExchangeValue => 'CME Group (NYMEX·COMEX)';

  @override
  String get dataSourcesSettlementLabel => '정산가·거래량';

  @override
  String get dataSourcesSettlementValue => 'Massive · 장 마감 후 반영';

  @override
  String get dataSourcesIntradayLabel => '장중 시세';

  @override
  String get dataSourcesIntradayValue => 'Yahoo Finance · 약 10분 지연';

  @override
  String get dataSourcesHistoryLabel => '과거 일봉';

  @override
  String get dataSourcesHistoryValue => 'Databento (2010-06~)';

  @override
  String get dataSourcesEtpKrLabel => '국내';

  @override
  String get dataSourcesEtpKrValue => '네이버 증권, KRX';

  @override
  String get dataSourcesEtpUsLabel => '미국';

  @override
  String get dataSourcesEtpUsValue => 'Nasdaq, Yahoo Finance';

  @override
  String get dataSourcesNotice =>
      '롤 규칙: S&P GSCI·Bloomberg 지수 방법론을 따라 앱이 계산한 값입니다. 개인 참고용이며 정확성을 보장하지 않고, 투자 권유가 아닙니다.';

  @override
  String get alertSettingsTitle => '알림 설정';

  @override
  String get alertSettingsPermissionOff => '⚠ 알림 권한이 꺼져 있습니다';

  @override
  String get alertSettingsPermissionAllow => '허용';

  @override
  String get alertSettingsPermissionOpenSettings => '설정 열기';

  @override
  String get alertSettingsCommodity => '대상 원자재';

  @override
  String get alertSettingsCommodityNone => '없음';

  @override
  String get alertSettingsCriteria => '현재 적용 기준';

  @override
  String alertSettingsCriteriaChart(String basis, int maPeriod, String window) {
    return '기준값 $basis · $maPeriod일선 · $window';
  }

  @override
  String alertSettingsCriteriaWindowYears(String years) {
    return '$years년';
  }

  @override
  String alertSettingsCriteriaLevels(String levels) {
    return '레벨 $levels% (위·아래)';
  }

  @override
  String get alertSettingsQuietTime => '알림 거부 시간';

  @override
  String get alertSettingsQuietStart => '시작';

  @override
  String get alertSettingsQuietEnd => '종료';

  @override
  String alertSettingsQuietNextDay(String time) {
    return '다음 날 $time';
  }

  @override
  String get alertSettingsQuietNote =>
      '이 시간에 생긴 알림은 종료 시각에 방향별로 가장 드문 1건만 보냅니다.';

  @override
  String get alertSettingsGuide =>
      '장중 15분마다 확인하며 레벨별로 CME 거래일당 1회 알려 드립니다. 차트의 rare-level 선에 오늘 봉의 꼬리가 닿으면 알립니다(장중 터치 기준이라 p%보다 자주 울릴 수 있음).';

  @override
  String get pushChannelAlerts => '시세 알림';

  @override
  String get pushChannelOps => '운영 알림';
}
