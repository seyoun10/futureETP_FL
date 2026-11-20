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
}
