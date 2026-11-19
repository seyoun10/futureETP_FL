import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// 가짜 응답. [error]가 있으면 던지고, [hang]이면 취소될 때까지 응답하지 않는다.
class FakeResponse {
  const new({this.status = 200, this.body = '', this.error, this.hang = false});

  /// 봉투 JSON 응답.
  factory json(Object envelope, {int status = 200}) =>
      FakeResponse(status: status, body: jsonEncode(envelope));

  /// `{ success: true, data }`.
  factory ok(Object? data) =>
      FakeResponse.json({'success': true, 'data': data});

  /// `{ success: false, error }`.
  factory fail(String code, int status) => FakeResponse.json({
    'success': false,
    'error': {'code': code, 'message': 'test'},
  }, status: status);

  final int status;
  final String body;
  final DioException? error;
  final bool hang;
}

/// 요청마다 [handler]로 응답을 고르는 dio 어댑터. 받은 요청과 본문을 기록한다.
class FakeHttpAdapter implements HttpClientAdapter {
  new(this.handler);

  /// 늘 같은 응답.
  factory always(FakeResponse response) => FakeHttpAdapter((_) => response);

  final FakeResponse Function(RequestOptions request) handler;
  final requests = <RequestOptions>[];
  final sentBodies = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream != null) {
      sentBodies.add(
        utf8.decode(await requestStream.expand((b) => b).toList()),
      );
    }
    final response = handler(options);
    if (response.error case final DioException error) throw error;
    if (response.hang) await Completer<void>().future;
    return ResponseBody.fromString(response.body, response.status);
  }

  @override
  void close({bool force = false}) {}
}
