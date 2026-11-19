import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 등락 색(D-031): 한국식 상승 빨강·하락 파랑, 미국식 상승 초록·하락 빨강.
enum UpDownStyle { kr, us }

/// 기기별 표시 설정(D-073). 서버 기기 설정과 달리 이 기기에만 저장한다.
/// 언어는 앱 표시 언어의 원본이고 서버 `locale`은 푸시 문구용 사본이다(D-082, D-137).
@immutable
class DisplaySettings {
  const new({required this.language, required this.upDownStyle});

  /// 기기 언어가 `ko`면 한국어, 그 밖은 영어. 기기 지역이 `KR`이면 한국식, 그 밖은 미국식(D-033, D-073).
  factory fromDevice(Locale? locale) => DisplaySettings(
    language: locale?.languageCode == 'ko' ? AppLanguage.ko : AppLanguage.en,
    upDownStyle: locale?.countryCode == 'KR' ? UpDownStyle.kr : UpDownStyle.us,
  );

  /// 저장된 값에서 읽는다. 없거나 모르는 값인 필드는 [fallback]을 쓴다.
  factory decode(String? stored, DisplaySettings fallback) {
    final json = _tryDecode(stored);
    return DisplaySettings(
      language:
          AppLanguage.values.asNameMap()[json['language']] ?? fallback.language,
      upDownStyle:
          UpDownStyle.values.asNameMap()[json['upDownStyle']] ??
          fallback.upDownStyle,
    );
  }

  final AppLanguage language;
  final UpDownStyle upDownStyle;

  Locale get locale => Locale(language.name);

  String encode() =>
      jsonEncode({'language': language.name, 'upDownStyle': upDownStyle.name});

  DisplaySettings copyWith({AppLanguage? language, UpDownStyle? upDownStyle}) =>
      DisplaySettings(
        language: language ?? this.language,
        upDownStyle: upDownStyle ?? this.upDownStyle,
      );

  @override
  bool operator ==(Object other) =>
      other is DisplaySettings &&
      other.language == language &&
      other.upDownStyle == upDownStyle;

  @override
  int get hashCode => Object.hash(language, upDownStyle);

  static Map<String, Object?> _tryDecode(String? text) {
    if (text == null) return const {};
    try {
      return switch (jsonDecode(text)) {
        final Map<String, Object?> map => map,
        _ => const {},
      };
    } on FormatException {
      return const {};
    }
  }
}

/// 저장 키(RN과 같은 이름).
const displaySettingsKey = 'display-settings';

/// `main`이 `runApp` 전에 만든다. 캐시가 있어 읽기가 동기라 첫 프레임부터 저장된 언어·색이다(D-030, D-073).
Future<SharedPreferencesWithCache> openDisplaySettingsStore() =>
    SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {displaySettingsKey},
      ),
    );

/// `main`에서 [openDisplaySettingsStore]로 덮어쓴다.
final displaySettingsStoreProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('override in main'),
);

/// 기기 언어·지역. 테스트에서 덮어쓴다.
final deviceLocaleProvider = Provider<Locale?>(
  (ref) => PlatformDispatcher.instance.locales.firstOrNull,
);

class DisplaySettingsNotifier extends Notifier<DisplaySettings> {
  @override
  DisplaySettings build() => DisplaySettings.decode(
    ref.watch(displaySettingsStoreProvider).getString(displaySettingsKey),
    DisplaySettings.fromDevice(ref.watch(deviceLocaleProvider)),
  );

  void setLanguage(AppLanguage language) =>
      _set(state.copyWith(language: language));

  void setUpDownStyle(UpDownStyle style) =>
      _set(state.copyWith(upDownStyle: style));

  /// 화면은 바로 바꾸고 저장은 뒤에서 한다. 저장 실패는 다음 실행에 이전 값이 될 뿐이다.
  void _set(DisplaySettings next) {
    if (next == state) return;
    state = next;
    unawaited(
      ref
          .read(displaySettingsStoreProvider)
          .setString(displaySettingsKey, next.encode())
          .catchError((Object error) {
            debugPrint('[display-settings] failed to save: $error');
          }),
    );
  }
}

final displaySettingsProvider =
    NotifierProvider<DisplaySettingsNotifier, DisplaySettings>(
      DisplaySettingsNotifier.new,
    );
