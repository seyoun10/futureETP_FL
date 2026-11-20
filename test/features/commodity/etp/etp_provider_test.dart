import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/features/commodity/etp/etp_provider.dart';

import '../../../helpers/fake_http.dart';

Map<String, Object?> _fixture(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync())
        as Map<String, Object?>;

void main() {
  test('목록은 원자재 경로로, 상세는 id 경로로 받는다', () async {
    final requests = <RequestOptions>[];
    final adapter = FakeHttpAdapter((req) {
      requests.add(req);
      return FakeResponse.ok(
        _fixture(req.path.startsWith('/etps/') ? 'etpDetail' : 'etpList'),
      );
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

    final list = etpListProvider(CommodityCode.gc);
    c.listen(list, (_, _) {});
    final etps = await c.read(list.future);
    expect(requests.single.path, '/commodities/GC/etps');
    expect(etps.etps, hasLength(23));

    const id = '9d468af9-3a01-4b91-9c08-63a5ee7a511a';
    final detail = etpDetailProvider(id);
    c.listen(detail, (_, _) {});
    final etp = await c.read(detail.future);
    expect(requests.last.path, '/etps/$id');
    expect(etp.series.single.ticker, 'UGL');
  });
}
