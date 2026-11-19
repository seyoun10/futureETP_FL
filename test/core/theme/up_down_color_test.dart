import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/display_store.dart';

// RN apps/mobile/src/theme/upDownColor.test.ts와 같은 경우
void main() {
  test('한국식은 상승 빨강·하락 파랑, 미국식은 상승 초록·하락 빨강', () {
    expect(UpDownPalette.of(UpDownStyle.kr).up, const Color(0xFFEF5350));
    expect(UpDownPalette.of(UpDownStyle.kr).down, const Color(0xFF42A5F5));
    expect(UpDownPalette.of(UpDownStyle.us).up, const Color(0xFF26A69A));
    expect(UpDownPalette.kr.up, UpDownPalette.us.down);
    expect(UpDownPalette.kr.flat, AppColors.neutral);
  });

  group('changeColor', () {
    const p = UpDownPalette.us;

    test('부호로 상승·하락 색을 고른다', () {
      expect(changeColor(0.5, p), p.up);
      expect(changeColor(-0.01, p), p.down);
    });

    test('0과 NaN은 방향 없는 색', () {
      expect(changeColor(0, p), p.flat);
      expect(changeColor(0 * -1.0, p), p.flat); // -0.0
      expect(changeColor(double.nan, p), p.flat);
    });

    test('자릿수를 주면 반올림해 보이는 값으로 고른다', () {
      expect(changeColor(-0.04, p, decimals: 1), p.flat);
      expect(changeColor(0.04, p, decimals: 1), p.flat);
      expect(changeColor(-0.05, p, decimals: 1), p.down);
      expect(changeColor(0.06, p, decimals: 1), p.up);
    });
  });

  group('changePairColor', () {
    const p = UpDownPalette.kr;

    test('변화량·등락률이 둘 다 반올림해 0이면 방향 없는 색', () {
      expect(changePairColor(0.0004, 0.004, 3, p), p.flat);
      expect(changePairColor(-0.04, -0.001, 1, p), p.flat);
    });

    test('둘 중 0이 아닌 쪽의 부호를 따른다', () {
      expect(changePairColor(0.0004, 0.014, 3, p), p.up);
      expect(changePairColor(-0.1, -0.002, 1, p), p.down);
    });
  });

  test('upDownPaletteProvider는 표시 설정을 따르고 같은 스타일이면 같은 객체', () async {
    final container = ProviderContainer(
      overrides: [
        displaySettingsStoreProvider.overrideWithValue(
          await openTestDisplayStore(),
        ),
        deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(upDownPaletteProvider), same(UpDownPalette.us));
    container
        .read(displaySettingsProvider.notifier)
        .setUpDownStyle(UpDownStyle.kr);
    expect(container.read(upDownPaletteProvider), same(UpDownPalette.kr));
  });
}
