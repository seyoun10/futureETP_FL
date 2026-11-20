import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';
import 'package:futureetp/core/widgets/freshness_line.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('ko')}) => testApp(
  locale: locale,
  home: Scaffold(body: child),
);

final _freshness = Freshness(
  asOf: DateTime.utc(2026, 10, 22, 14),
  tradeDate: '2026-10-22',
  delayed: true,
  marketState: MarketState.open,
  nextUpdateAt: null,
);

Future<void> _pumpQuery(
  WidgetTester tester,
  AsyncValue<String> value, {
  VoidCallback? onRetry,
}) => tester.pumpWidget(
  _wrap(
    QueryStateView<String>(
      value: value,
      onRetry: onRetry ?? () {},
      builder: (context, data) => Text(data),
    ),
  ),
);

/// 조회마다 [_results]에서 하나씩 꺼낸다: 값·에러·끝나지 않는 [Completer].
var _results = <Object>[];

final _query = FutureProvider<String>((ref) {
  final next = _results.removeAt(0);
  return switch (next) {
    final Completer<String> c => c.future,
    final String value => Future.value(value),
    _ => Future.error(next),
  };
});

/// [_query]를 그리는 화면. 재시도 없이 첫 결과까지 기다린다.
Future<ProviderContainer> _pumpProvider(
  WidgetTester tester,
  List<Object> results,
) async {
  _results = results;
  final container = ProviderContainer(retry: (_, _) => null);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: _wrap(
        Consumer(
          builder: (context, ref, _) => QueryStateView<String>(
            value: ref.watch(_query),
            onRetry: () => ref.invalidate(_query),
            builder: (context, data) => Text(data),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return container;
}

void main() {
  group('FreshnessLine', () {
    testWidgets('기준 시각·거래일·지연·장 상태를 한 줄로 보여 준다', (tester) async {
      await tester.pumpWidget(_wrap(FreshnessLine(_freshness)));
      expect(
        find.textContaining(
          RegExp(r'^\d{2}/\d{2} \d{2}:\d{2} 기준 · 거래일 10/22 · 지연 · 장중$'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('지연이 아니면 지연을 빼고, 정산 대기를 보여 준다', (tester) async {
      await tester.pumpWidget(
        _wrap(
          FreshnessLine(
            _freshness.copyWith(
              delayed: false,
              marketState: MarketState.settlementPending,
            ),
          ),
        ),
      );
      expect(
        find.textContaining(RegExp(r' · 거래일 10/22 · 정산 대기$')),
        findsOneWidget,
      );
    });

    testWidgets('영어 문구', (tester) async {
      await tester.pumpWidget(
        _wrap(
          FreshnessLine(_freshness.copyWith(marketState: MarketState.closed)),
          locale: const Locale('en'),
        ),
      );
      expect(
        find.textContaining(
          RegExp(r'^As of .+ · Trade date 10/22 · Delayed · Closed$'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('기준 시각만', (tester) async {
      await tester.pumpWidget(
        _wrap(FreshnessLine.asOfOnly(DateTime.utc(2026, 10, 22, 14))),
      );
      expect(
        find.textContaining(RegExp(r'^\d{2}/\d{2} \d{2}:\d{2} 기준$')),
        findsOneWidget,
      );
    });

    testWidgets('줄이 없어도 빈 줄로 자리를 지킨다', (tester) async {
      await tester.pumpWidget(_wrap(const FreshnessFooter()));
      expect(find.text(' '), findsOneWidget);
    });
  });

  group('QueryStateView', () {
    testWidgets('처음 로딩 중에는 스켈레톤과 가운데 스피너', (tester) async {
      await _pumpQuery(tester, const AsyncLoading());
      expect(find.bySemanticsLabel('불러오는 중'), findsOneWidget);
      expect(find.byKey(CenterSpinner.spinnerKey), findsOneWidget);
    });

    testWidgets('처음 로딩이 실패하면 code 문구와 [다시 시도], 누르면 다시 조회', (tester) async {
      var retried = 0;
      await _pumpQuery(
        tester,
        const AsyncError(AppError(AppErrorCode.network), StackTrace.empty),
        onRetry: () => retried++,
      );
      expect(find.text('네트워크에 연결할 수 없습니다.'), findsOneWidget);
      await tester.tap(find.text('다시 시도'));
      expect(retried, 1);
    });

    testWidgets('다시 시도 중에는 오류 대신 스켈레톤', (tester) async {
      final c = await _pumpProvider(tester, [
        const AppError(AppErrorCode.network),
        Completer<String>(),
      ]);
      expect(find.text('다시 시도'), findsOneWidget);
      c.invalidate(_query);
      await tester.pump();
      expect(find.bySemanticsLabel('불러오는 중'), findsOneWidget);
      expect(find.text('다시 시도'), findsNothing);
    });

    testWidgets('AppError가 아닌 오류는 서버 오류 문구', (tester) async {
      await _pumpQuery(tester, AsyncError(Exception('boom'), StackTrace.empty));
      expect(find.textContaining('서버에 문제가 생겼습니다'), findsOneWidget);
    });

    testWidgets('데이터가 있으면 새로고침이 실패해도 데이터를 보여 준다', (tester) async {
      final c = await _pumpProvider(tester, [
        '이전 값',
        const AppError(AppErrorCode.timeout),
      ]);
      c.invalidate(_query);
      await tester.pump();
      expect(c.read(_query).hasError, isTrue);
      expect(find.text('이전 값'), findsOneWidget);
      expect(find.text('다시 시도'), findsNothing);
    });
  });
}
