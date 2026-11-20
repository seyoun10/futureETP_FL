import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/features/commodity/curve/curve_provider.dart';

import '../../../helpers/fake_http.dart';

void main() {
  test('기준일이 없으면 query 없이, 있으면 baseDate로 받는다', () async {
    final requests = <RequestOptions>[];
    final adapter = FakeHttpAdapter((req) {
      requests.add(req);
      return FakeResponse.ok(
        jsonDecode(File('test/contract/fixtures/curve.json').readAsStringSync())
            as Map<String, Object?>,
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

    final latest = curveProvider((code: CommodityCode.gc, baseDate: null));
    c.listen(latest, (_, _) {});
    final curve = await c.read(latest.future);
    expect(requests.single.path, '/commodities/GC/curve');
    expect(requests.single.queryParameters, isEmpty);
    expect(curve.points, hasLength(7));

    final past = curveProvider((
      code: CommodityCode.gc,
      baseDate: '2026-10-16',
    ));
    c.listen(past, (_, _) {});
    await c.read(past.future);
    expect(requests.last.queryParameters, {'baseDate': '2026-10-16'});
  });
}
