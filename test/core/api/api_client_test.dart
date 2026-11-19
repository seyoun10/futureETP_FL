import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';

/// 정해진 응답 본문을 돌려주는 어댑터.
class _FakeAdapter implements HttpClientAdapter {
  new(this.body);

  final Object body;
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiClient _client(_FakeAdapter adapter) => ApiClient(
  Dio(BaseOptions(baseUrl: 'http://test/v1'))..httpClientAdapter = adapter,
);

void main() {
  test('getHealth는 /v1/health의 data를 읽는다', () async {
    final adapter = _FakeAdapter({
      'success': true,
      'data': {'status': 'ok', 'commit': 'abc123'},
    });
    final health = await _client(adapter).getHealth();
    expect(adapter.last?.uri.toString(), 'http://test/v1/health');
    expect(health.status, 'ok');
    expect(health.commit, 'abc123');
  });

  test('commit은 null일 수 있다', () async {
    final adapter = _FakeAdapter({
      'success': true,
      'data': {'status': 'ok', 'commit': null},
    });
    expect((await _client(adapter).getHealth()).commit, isNull);
  });

  test('봉투나 data가 스키마와 다르면 FormatException', () async {
    final bad = [
      {
        'success': false,
        'error': {'code': 'INTERNAL', 'message': 'x'},
      },
      {
        'success': true,
        'data': {'status': 'down', 'commit': null},
      },
      {
        'success': true,
        'data': {'status': 'ok'},
      },
    ];
    for (final body in bad) {
      await expectLater(
        _client(_FakeAdapter(body)).getHealth(),
        throwsFormatException,
      );
    }
  });
}
