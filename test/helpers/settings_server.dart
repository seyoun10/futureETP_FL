import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/config/app_version.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_http.dart';

/// 기기 설정 서버 흉내(`GET·PATCH /v1/settings`). PATCH는 받은 필드를 덮고 rare 레벨을 정렬한다.
/// [failWith]가 있으면 PATCH를 그 (코드, 상태)로 거절한다.
class SettingsServer {
  new({Map<String, Object?>? initial}) : settings = {..._fixture, ...?initial};

  static final Map<String, Object?> _fixture = jsonDecode(
    File('test/contract/fixtures/settings.json').readAsStringSync(),
  ) as Map<String, Object?>;

  final Map<String, Object?> settings;
  final patches = <Map<String, Object?>>[];
  (String, int)? failWith;

  late final FakeHttpAdapter adapter = FakeHttpAdapter((req) {
    if (req.path != '/settings') return FakeResponse.fail('NOT_FOUND', 404);
    if (req.method == 'PATCH') {
      final body = jsonDecode(adapter.sentBodies.last) as Map<String, Object?>;
      patches.add(body);
      if (failWith case (final code, final status)) {
        return FakeResponse.fail(code, status);
      }
      settings.addAll(body);
      if (body['rareLevels'] case final List<Object?> levels) {
        settings['rareLevels'] = [...levels.cast<num>()]..sort();
      }
    }
    return FakeResponse.ok(settings);
  });

  /// 화면 테스트의 ProviderScope overrides.
  List<Override> overrides(SharedPreferencesWithCache displayStore) => [
    displaySettingsStoreProvider.overrideWithValue(displayStore),
    storedAccessKeyProvider.overrideWithValue('key'),
    appVersionProvider.overrideWith(
      (ref) async => (version: '1.0.0', build: '1'),
    ),
    apiClientProvider.overrideWithValue(
      ApiClient(
        Dio(BaseOptions(baseUrl: 'http://test/v1'))
          ..httpClientAdapter = adapter,
        accessToken: () async => 'key',
        deviceId: () async => 'id',
      ),
    ),
  ];
}
