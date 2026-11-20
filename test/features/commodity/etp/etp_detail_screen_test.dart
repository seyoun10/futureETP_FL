import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/features/commodity/etp/etp_detail_screen.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/fake_http.dart';

const _id = '9d468af9-3a01-4b91-9c08-63a5ee7a511a';

Map<String, Object?> _detail() =>
    jsonDecode(File('test/contract/fixtures/etpDetail.json').readAsStringSync())
        as Map<String, Object?>;

late List<Uri> _opened;

Future<void> _pump(WidgetTester tester, Map<String, Object?> data) async {
  _opened = [];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(
          ApiClient(
            Dio(BaseOptions(baseUrl: 'http://test/v1'))
              ..httpClientAdapter = FakeHttpAdapter.always(
                FakeResponse.ok(data),
              ),
            accessToken: () async => 'key',
            deviceId: () async => 'id',
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EtpDetailScreen(
          id: _id,
          openUrl: (url) async => _opened.add(url),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('제목은 상품명이고, 항목·종목코드를 보여 주며 운용사 페이지를 연다', (tester) async {
    await _pump(tester, _detail());
    expect(find.text('ProShares Ultra Gold'), findsOneWidget);
    for (final text in [
      'Gold',
      'US',
      'ETF',
      '2x',
      'N/A',
      'ProShares',
      'Bloomberg Gold Subindex',
      '0.95%',
      '2008-12-03',
      'UGL',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    await tester.tap(find.byKey(const Key('etp-open-issuer')));
    expect(_opened, [Uri.parse('https://www.proshares.com/')]);
  });

  testWidgets('ETN 시리즈는 줄마다 시리즈·종목코드·만기, 값이 없으면 —, 웹 주소가 아니면 링크 없음', (
    tester,
  ) async {
    await _pump(tester, {
      ..._detail(),
      'issuer': null,
      'expenseRatio': null,
      'issuerUrl': 'javascript:alert(1)',
      'series': [
        {'ticker': '530031', 'seriesCode': 'A', 'maturityDate': '2027-03-15'},
        {'ticker': '530032', 'seriesCode': 'B', 'maturityDate': '2029-03-15'},
      ],
    });
    expect(
      find.text(
        'Series A · 530031 · Matures 2027-03-15\n'
        'Series B · 530032 · Matures 2029-03-15',
      ),
      findsOneWidget,
    );
    expect(find.text('—'), findsNWidgets(2));
    expect(find.byKey(const Key('etp-open-issuer')), findsNothing);
  });
}
