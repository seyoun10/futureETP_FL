import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_chart_provider.dart';

import '../../../helpers/fake_http.dart';

Map<String, Object?> _fixture() => jsonDecode(
  File('test/contract/fixtures/contractsChart.json').readAsStringSync(),
) as Map<String, Object?>;

/// 이전 3년 응답: 2023년 날짜 2개, 첫 월물(GCZ26)과 fixture에 없는 월물, 더 받을 것 없음.
Map<String, Object?> _olderPage() {
  final page = _fixture();
  final first = (page['contracts']! as List).first as Map<String, Object?>;
  return {
    ...page,
    'dates': ['2023-01-03', '2023-01-04'],
    'hasMore': false,
    'contracts': [
      {
        ...first,
        'prices': [1800.1, 1801.2],
      },
      {
        ...first,
        'symbol': 'GCZ23',
        'prices': [1700.0, 1700.5],
      },
    ],
  };
}

late List<RequestOptions> _requests;

/// 과거·최근 응답 지연(진행 중인 받기와 다시 조회가 겹치는 경우).
Duration? _olderDelay;
Duration? _latestDelay;

ProviderContainer _container() {
  _requests = [];
  final adapter = FakeHttpAdapter((req) {
    _requests.add(req);
    return req.queryParameters.containsKey('before')
        ? FakeResponse.ok(_olderPage(), delay: _olderDelay)
        : FakeResponse.ok(_fixture(), delay: _latestDelay);
  });
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      apiClientProvider.overrideWithValue(
        ApiClient(
          Dio(BaseOptions(baseUrl: 'http://test/v1'))
            ..httpClientAdapter = adapter,
          accessToken: () async => 'key',
          deviceId: () async => 'id',
        ),
      ),
    ],
  );
  addTearDown(c.dispose);
  // 화면처럼 듣고 있는 상태로 둔다
  c.listen(_gc, (_, _) {});
  return c;
}

final AsyncNotifierProvider<ContractChartNotifier, ContractsChart> _gc =
    contractChartProvider(CommodityCode.gc);

void main() {
  setUp(() {
    _olderDelay = null;
    _latestDelay = null;
  });

  test('최근 3년을 받는다', () async {
    final c = _container();
    final chart = await c.read(_gc.future);
    expect(_requests.single.path, '/commodities/GC/contracts');
    expect(_requests.single.queryParameters, isEmpty);
    expect(chart.dates, hasLength(60));
    expect(chart.contracts, hasLength(5));
  });

  test('이전 3년은 가장 이른 날짜 전으로 받아 앞에 붙이고, 없는 월물은 null로 채운다', () async {
    final c = _container();
    await c.read(_gc.future);
    await c.read(_gc.notifier).loadOlder();

    expect(_requests.last.queryParameters['before'], '2026-08-07');
    final chart = c.read(_gc).requireValue;
    expect(chart.dates, hasLength(62));
    expect(chart.dates.take(3), ['2023-01-03', '2023-01-04', '2026-08-07']);
    expect(chart.hasMore, isFalse);
    // 월물 목록은 최근 응답을 따른다(이전 응답에만 있는 GCZ23은 버림)
    expect(chart.contracts.map((l) => l.symbol), [
      'GCZ26',
      'GCG27',
      'GCJ27',
      'GCM27',
      'GCQ27',
    ]);
    for (final l in chart.contracts) {
      expect(l.prices, hasLength(62));
    }
    expect(chart.contracts[0].prices.take(3), [1800.1, 1801.2, 4399.7]);
    expect(chart.contracts[1].prices.take(3), [null, null, 4435.3]);

    await c.read(_gc.notifier).loadOlder();
    expect(_requests, hasLength(2));
  });

  test('다시 조회하면 최근 3년만 받고 과거 날짜는 이어 붙인다', () async {
    final c = _container();
    await c.read(_gc.future);
    await c.read(_gc.notifier).loadOlder();

    c.invalidate(_gc);
    final chart = await c.read(_gc.future);
    expect(_requests, hasLength(3));
    expect(_requests.last.queryParameters.containsKey('before'), isFalse);
    expect(chart.dates, hasLength(62));
    expect(chart.contracts[0].prices.take(2), [1800.1, 1801.2]);
    expect(chart.hasMore, isFalse);
  });

  // RN dfa05cf: 자동 새로고침이 진행 중인 과거 받기를 취소하지 않는다
  for (final (name, older, latest) in [
    ('다시 조회가 먼저 끝나도', 50, 10),
    ('과거 받기가 먼저 끝나도', 10, 50),
  ]) {
    test('과거 받기 중 다시 조회해도 과거 날짜가 남는다($name)', () async {
      final c = _container();
      await c.read(_gc.future);
      _olderDelay = Duration(milliseconds: older);
      _latestDelay = Duration(milliseconds: latest);

      final loading = c.read(_gc.notifier).loadOlder();
      c.invalidate(_gc);
      final refreshed = c.read(_gc.future);
      await Future.wait([loading, refreshed]);
      await Future<void>.delayed(Duration.zero);

      final chart = c.read(_gc).requireValue;
      expect(chart.dates, hasLength(62));
      expect(chart.dates.first, '2023-01-03');
      expect(chart.hasMore, isFalse);
    });
  }
}
