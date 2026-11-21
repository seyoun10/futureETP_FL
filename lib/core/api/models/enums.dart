import 'package:json_annotation/json_annotation.dart';

// 계약(`../futureETP/packages/shared/contract/schemas/*.json`)의 enum 값.
// 모르는 값은 디코딩 실패 → SCHEMA_MISMATCH(D-042).

/// 원자재 코드(api.json `pathParams.code`).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CommodityCode {
  gc,
  si,
  cl,
  ng;

  /// 경로·서버 값(`GC`).
  String get wire => name.toUpperCase();

  /// 경로 값(`GC`)의 코드. 모르는 값이면 null.
  static CommodityCode? fromWire(String? value) {
    for (final code in values) {
      if (code.wire == value) return code;
    }
    return null;
  }
}

/// 장 상태(D-022).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum MarketState { open, closed, settlementPending }

/// 이격도 기준 지수(대표월물·한국 ETP·미국 ETP).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Basis { front, kr, us }

/// 이평선 기간(거래일).
@JsonEnum(valueField: 'days')
enum MaPeriod {
  ma20(20),
  ma50(50),
  ma100(100),
  ma200(200);

  new(this.days);

  final int days;
}

/// rare 레벨 분포 기간.
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum DistributionWindow { y3, y5, y10, all }

/// rare 레벨·꼬리 방향.
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Direction { up, down }

/// 월물커브 상태.
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CurveState { contango, backwardation, flat }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum EtpMarket { krx, us }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum EtpType { etf, etn }

/// 환헤지(`NA`는 해당 없음).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum FxHedge { hedged, unhedged, na }

/// 서버에 보내는 언어(푸시 문구, D-120)·ETP 이름 언어.
enum AppLanguage { ko, en }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum DevicePlatform { ios, android }

/// 휴장 달력 시장(calendar.json, D-143).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CalendarMarket { cme, krx, nyse }

/// 휴장 달력 예외 종류(calendar.json, D-143). `CLOSED`·`HALT`는 휴장(채운 점),
/// `EARLY_CLOSE`·`LATE_OPEN`은 조기 마감·개장 지연(빈 점).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CalendarExceptionKind { closed, halt, earlyClose, lateOpen }
