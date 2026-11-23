import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/etp.dart';
import 'package:futureetp/features/commodity/etp/etp_list_model.dart';

EtpSummary _etp(
  String name, {
  EtpMarket market = EtpMarket.krx,
  EtpType type = EtpType.etf,
  double leverage = 1,
  FxHedge fxHedge = FxHedge.hedged,
  double? aum,
  double? tradingValue,
}) => EtpSummary(
  id: name,
  market: market,
  type: type,
  leverage: leverage,
  fxHedge: fxHedge,
  name: name,
  tickers: const [],
  aum: aum,
  avgTradingValue: tradingValue,
);

List<String> _names(List<EtpSummary> etps) => [for (final e in etps) e.name];

void main() {
  final etps = [
    _etp('US-b', market: EtpMarket.us, aum: 5, fxHedge: FxHedge.na),
    _etp('KR-inv', leverage: -1, aum: 30),
    _etp('KR-2x', leverage: 2, type: EtpType.etn),
    _etp('kr-a', aum: 10, tradingValue: 7),
    _etp('KR-b', aum: 20, fxHedge: FxHedge.unhedged),
    _etp('US-a', market: EtpMarket.us, leverage: -2, aum: 50),
  ];

  test('기본 정렬: 시장(KRX → US), 배수(양수 먼저·절댓값), 이름(대소문자 무시)', () {
    expect(_names(sortEtps(etps, EtpSort.byDefault)), [
      'kr-a',
      'KR-b',
      'KR-2x',
      'KR-inv',
      'US-b',
      'US-a',
    ]);
  });

  test('순자산 정렬은 시장 안에서 큰 순서, 값이 없으면 뒤로', () {
    expect(_names(sortEtps(etps, EtpSort.aum)), [
      'KR-inv',
      'KR-b',
      'kr-a',
      'KR-2x',
      'US-a',
      'US-b',
    ]);
  });

  test('필터는 null(전체)이 아닌 조건만 거른다', () {
    expect(
      _names(
        filterEtps(etps, (
          market: EtpMarket.krx,
          type: EtpType.etf,
          leverage: 1,
          fxHedge: null,
        )),
      ),
      ['kr-a', 'KR-b'],
    );
    expect(filterEtps(etps, noEtpFilters), hasLength(etps.length));
  });

  test('배수 선택지는 받은 상품의 배수만, 양수 먼저 절댓값 순', () {
    expect(leverageOptions(etps), [1, 2, -1, -2]);
  });

  test('정렬 값: 기본은 붙이지 않고, 값이 없으면 null', () {
    expect(sortValue(etps[3], EtpSort.byDefault).hasValue, isFalse);
    expect(sortValue(etps[3], EtpSort.tradingValue), (
      hasValue: true,
      value: 7,
    ));
    expect(sortValue(etps[2], EtpSort.aum), (hasValue: true, value: null));
  });

  test('배수 표기는 정수면 소수점이 없다', () {
    expect(plainNumber(2), '2');
    expect(plainNumber(-1), '-1');
    expect(plainNumber(1.5), '1.5');
  });

  test('이름순: 한국어 기기면 한글이 라틴 앞, 아니면 라틴이 앞이고 숫자·기호는 문자 앞이다', () {
    final names = ['TIGER', '신한', 'kodex', '메리츠', '1x', 'ACE'];
    List<String> sorted({required bool hangulFirst}) =>
        [...names]
          ..sort((a, b) => compareEtpName(a, b, hangulFirst: hangulFirst));
    expect(sorted(hangulFirst: true), [
      '1x',
      '메리츠',
      '신한',
      'ACE',
      'kodex',
      'TIGER',
    ]);
    expect(sorted(hangulFirst: false), [
      '1x',
      'ACE',
      'kodex',
      'TIGER',
      '메리츠',
      '신한',
    ]);
  });
}
