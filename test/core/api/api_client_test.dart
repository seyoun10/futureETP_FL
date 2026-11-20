import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/models/device.dart';
import 'package:futureetp/core/api/models/enums.dart';

import '../../helpers/fake_http.dart';

const _deviceId = '3f2c1a9e-8b7d-4c6e-9f1a-2b3c4d5e6f70';

ApiClient _client(
  FakeHttpAdapter adapter, {
  String? token = 'stored-key',
  Duration timeout = ApiClient.defaultTimeout,
}) => ApiClient(
  Dio(BaseOptions(baseUrl: 'http://test/v1'))..httpClientAdapter = adapter,
  accessToken: () async => token,
  deviceId: () async => _deviceId,
  timeout: timeout,
);

Object? _identity(Object? data) => data;

FakeHttpAdapter _json(Object envelope, {int status = 200}) =>
    FakeHttpAdapter.always(FakeResponse.json(envelope, status: status));

Matcher _appError(AppErrorCode code, {int? status}) => isA<AppError>()
    .having((e) => e.code, 'code', code)
    .having((e) => e.status, 'status', status);

void main() {
  group('요청', () {
    test('health는 인증 헤더 없이 보내고 data를 읽는다', () async {
      final adapter = _json({
        'success': true,
        'data': {'status': 'ok', 'commit': 'abc123'},
      });
      final health = await _client(adapter, token: null).getHealth();
      expect(health.commit, 'abc123');
      final req = adapter.requests.single;
      expect(req.uri.toString(), 'http://test/v1/health');
      expect(req.headers.containsKey('Authorization'), isFalse);
      expect(req.headers.containsKey('X-Device-Id'), isFalse);
    });

    test('인증 요청은 Bearer 키와 X-Device-Id를 보내고 null query는 뺀다', () async {
      final adapter = _json({'success': true, 'data': 1});
      await _client(adapter).request(
        '/commodities/GC/disparity',
        _identity,
        query: {'basis': 'FRONT', 'ma': 200, 'before': null},
      );
      final req = adapter.requests.single;
      expect(
        req.uri.toString(),
        'http://test/v1/commodities/GC/disparity?basis=FRONT&ma=200',
      );
      expect(req.method, 'GET');
      expect(req.headers['Authorization'], 'Bearer stored-key');
      expect(req.headers['X-Device-Id'], _deviceId);
    });

    test('token을 주면 저장된 키 대신 보낸다', () async {
      final adapter = _json({'success': true, 'data': 1});
      await _client(adapter).request('/settings', _identity, token: 'new-key');
      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer new-key',
      );
    });

    test('PATCH는 본문을 JSON으로 보낸다', () async {
      final adapter = _json({'success': true, 'data': 1});
      await _client(adapter).request(
        '/settings',
        _identity,
        method: ApiMethod.patch,
        body: {'language': 'en'},
      );
      final req = adapter.requests.single;
      expect(req.method, 'PATCH');
      expect(req.contentType, startsWith('application/json'));
      expect(jsonDecode(adapter.sentBodies.single), {'language': 'en'});
    });

    test('putDevice는 PUT /devices로 등록 본문을 보낸다', () async {
      final adapter = _json({
        'success': true,
        'data': {'id': _deviceId},
      });
      final device = await _client(adapter).putDevice(
        const DeviceRegistration(
          pushToken: 'fcm-token',
          platform: DevicePlatform.android,
          appVersion: 'fl-1.0.0',
        ),
      );
      expect(device.id, _deviceId);
      final req = adapter.requests.single;
      expect(req.method, 'PUT');
      expect(req.uri.toString(), 'http://test/v1/devices');
      expect(jsonDecode(adapter.sentBodies.single), {
        'pushToken': 'fcm-token',
        'platform': 'ANDROID',
        'appVersion': 'fl-1.0.0',
      });
    });

    test('키가 없으면 요청하지 않고 UNAUTHORIZED', () async {
      final adapter = _json({'success': true, 'data': 1});
      await expectLater(
        _client(adapter, token: null).request('/settings', _identity),
        throwsA(_appError(AppErrorCode.unauthorized)),
      );
      expect(adapter.requests, isEmpty);
    });
  });

  group('응답 봉투', () {
    test('에러 봉투는 서버 코드와 HTTP 상태', () async {
      final cases = {
        401: 'UNAUTHORIZED',
        429: 'RATE_LIMITED',
        400: 'VALIDATION_FAILED',
        404: 'NOT_FOUND',
        500: 'INTERNAL',
      };
      for (final MapEntry(key: status, value: code) in cases.entries) {
        final adapter = _json({
          'success': false,
          'error': {'code': code, 'message': 'x'},
        }, status: status);
        await expectLater(
          _client(adapter).request('/settings', _identity),
          throwsA(_appError(AppErrorCode.parseServer(code)!, status: status)),
        );
      }
    });

    test('봉투가 아니면 5xx는 INTERNAL, 그 밖은 SCHEMA_MISMATCH', () async {
      final cases = <(int, String), AppErrorCode>{
        (502, '<html>Bad Gateway</html>'): AppErrorCode.internal,
        (200, '<html></html>'): AppErrorCode.schemaMismatch,
        (200, ''): AppErrorCode.schemaMismatch,
        (200, '{"data":1}'): AppErrorCode.schemaMismatch,
        // 모르는 에러 코드(서버가 더 새 버전)
        (400, '{"success":false,"error":{"code":"NEW_CODE","message":"x"}}'):
            AppErrorCode.schemaMismatch,
        (503, '{"success":false,"error":{"code":"NEW_CODE","message":"x"}}'):
            AppErrorCode.internal,
      };
      for (final MapEntry(key: (status, body), value: code) in cases.entries) {
        await expectLater(
          _client(
            FakeHttpAdapter.always(FakeResponse(status: status, body: body)),
          ).request('/settings', _identity),
          throwsA(_appError(code, status: status)),
          reason: '$status $body',
        );
      }
    });

    test('data가 모델과 다르면 SCHEMA_MISMATCH', () async {
      final adapter = _json({
        'success': true,
        'data': {'status': 'ok'},
      });
      await expectLater(
        _client(adapter).getHealth(),
        throwsA(_appError(AppErrorCode.schemaMismatch, status: 200)),
      );
    });
  });

  group('전송 실패', () {
    test('연결 실패는 NETWORK', () async {
      final adapter = FakeHttpAdapter.always(
        FakeResponse(
          error: DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: 'refused',
          ),
        ),
      );
      await expectLater(
        _client(adapter).getHealth(),
        throwsA(_appError(AppErrorCode.network)),
      );
    });

    test('전체 시간이 넘으면 TIMEOUT', () async {
      final adapter = FakeHttpAdapter.always(const FakeResponse(hang: true));
      await expectLater(
        _client(adapter, timeout: const Duration(milliseconds: 20)).getHealth(),
        throwsA(_appError(AppErrorCode.timeout)),
      );
    });

    test('호출자 취소는 AppError가 아닌 DioException 그대로', () async {
      final adapter = FakeHttpAdapter.always(const FakeResponse(hang: true));
      final cancel = CancelToken();
      final future = _client(adapter).getHealth(cancelToken: cancel);
      cancel.cancel();
      await expectLater(
        future,
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.cancel,
          ),
        ),
      );
    });
  });
}
