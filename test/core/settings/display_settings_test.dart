import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/display_store.dart';

Future<ProviderContainer> _container({
  String? stored,
  Locale? device = const Locale('en', 'US'),
}) async {
  final store = await openTestDisplayStore(stored: stored);
  final container = ProviderContainer(
    overrides: [
      displaySettingsStoreProvider.overrideWithValue(store),
      deviceLocaleProvider.overrideWithValue(device),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('기기 기본값', () {
    test('ko면 한국어, KR이면 한국식', () {
      expect(
        DisplaySettings.fromDevice(const Locale('ko', 'KR')),
        const DisplaySettings(
          language: AppLanguage.ko,
          upDownStyle: UpDownStyle.kr,
        ),
      );
    });

    test('언어와 지역은 따로 본다', () {
      expect(
        DisplaySettings.fromDevice(const Locale('ko', 'US')),
        const DisplaySettings(
          language: AppLanguage.ko,
          upDownStyle: UpDownStyle.us,
        ),
      );
      expect(
        DisplaySettings.fromDevice(const Locale('ja', 'KR')),
        const DisplaySettings(
          language: AppLanguage.en,
          upDownStyle: UpDownStyle.kr,
        ),
      );
    });

    test('기기 언어를 모르면 영어·미국식', () {
      expect(
        DisplaySettings.fromDevice(null),
        const DisplaySettings(
          language: AppLanguage.en,
          upDownStyle: UpDownStyle.us,
        ),
      );
    });
  });

  group('저장', () {
    test('저장된 값이 없으면 기기 기본값', () async {
      final c = await _container(device: const Locale('ko', 'KR'));
      expect(c.read(displaySettingsProvider).language, AppLanguage.ko);
      expect(c.read(displaySettingsProvider).locale, const Locale('ko'));
    });

    test('저장된 값이 기기 기본값보다 앞선다', () async {
      final c = await _container(
        stored: '{"language":"ko","upDownStyle":"kr"}',
      );
      expect(
        c.read(displaySettingsProvider),
        const DisplaySettings(
          language: AppLanguage.ko,
          upDownStyle: UpDownStyle.kr,
        ),
      );
    });

    test('깨졌거나 모르는 값은 그 필드만 기기 기본값', () async {
      for (final stored in ['not json', '[1]', '{"language":"fr"}']) {
        final c = await _container(stored: stored);
        expect(
          c.read(displaySettingsProvider),
          const DisplaySettings(
            language: AppLanguage.en,
            upDownStyle: UpDownStyle.us,
          ),
          reason: stored,
        );
      }
      final c = await _container(stored: '{"language":"ko","upDownStyle":1}');
      expect(c.read(displaySettingsProvider).language, AppLanguage.ko);
      expect(c.read(displaySettingsProvider).upDownStyle, UpDownStyle.us);
    });

    test('바꾸면 바로 반영하고 저장한다(다음 실행에 남는다)', () async {
      final c = await _container();
      c.read(displaySettingsProvider.notifier)
        ..setLanguage(AppLanguage.ko)
        ..setUpDownStyle(UpDownStyle.kr);
      expect(c.read(displaySettingsProvider).language, AppLanguage.ko);
      await pumpEventQueue();

      // 같은 플랫폼 저장소를 새로 열면(앱 재실행) 저장된 값이다
      final reopened = await openDisplaySettingsStore();
      expect(jsonDecode(reopened.getString(displaySettingsKey)!), {
        'language': 'ko',
        'upDownStyle': 'kr',
      });
    });
  });
}
