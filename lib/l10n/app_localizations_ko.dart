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
  String get devChartSpikeTitle => '차트 스파이크';

  @override
  String devChartSpikeStats(int fps, String worst, int bars) {
    return '${fps}fps · 최악 ${worst}ms · 봉 $bars개';
  }

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
}
