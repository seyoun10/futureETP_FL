import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_periods.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/period_chips.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/failed_alert.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:futureetp/features/commodity/chart_busy.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 이전 3년 받기가 이 시간 안에 끝나지 않으면 로딩·차단을 거두고 실패 Alert를 띄운다(D-139).
const olderLoadTimeout = Duration(seconds: 5);

/// C-a·C-c 차트 탭 공통 상태
/// (RN `useChartPeriodView`·`useOlderPages`·`useReportChartBusy`).
///
/// - 기간: 탭 State에 둔다. indexedStack이 C에 있는 동안 탭을 살려 두므로 C를 떠나면 잊는다(D-107).
/// - 보이는 범위·십자선: [viewport]·[crosshair]. 차트·상세 박스가 듣는다.
/// - 이전 3년 받기(D-104, D-108, D-139): 가장 과거 봉이 보이면 받는다. 회차 번호로 시간 초과로 거둔
///   회차의 늦은 응답이 상태를 다시 바꾸지 않게 한다(데이터는 Provider가 그대로 붙인다).
mixin ChartTabState<W extends ConsumerStatefulWidget> on ConsumerState<W> {
  /// 지금 데이터의 봉(날짜) 수.
  int get barCount;

  /// 더 이전 데이터가 있는지.
  bool get hasMore;

  /// 이전 3년을 받아 앞에 붙인다. 실패는 던진다.
  Future<void> loadOlder();

  /// 고른 기간.
  ChartPeriod period = ChartPeriod.initial;

  /// 제스처로 범위를 바꿨는지. 핀치면 기간 칩 선택 표시를 지운다. null이면 기간의 최근 위치다.
  ChartGesture? gesture;

  late final ValueNotifier<ChartViewport> viewport = ValueNotifier(
    ChartViewport.latest(barCount, period.bars),
  );
  final crosshair = ValueNotifier<int?>(null);

  var _loadingOlder = false;
  var _olderRun = 0;
  Timer? _olderTimer;
  late final ChartBusyNotifier _busy = ref.read(chartBusyProvider.notifier);

  /// 이전 3년을 받는 중인지. 차트 `locked`에 넘긴다.
  bool get loadingOlder => _loadingOlder;

  @override
  void initState() {
    super.initState();
    viewport.addListener(maybeLoadOlder);
  }

  @override
  void dispose() {
    _olderRun++;
    _olderTimer?.cancel();
    if (_loadingOlder) _busy.set(busy: false);
    viewport.dispose();
    crosshair.dispose();
    super.dispose();
  }

  /// 가장 과거 봉이 화면에 보이고 더 받을 것이 있으면 이전 3년을 받는다.
  /// 그 자리에서 제스처가 끝날 때도 부른다(다시 끌면 다시 받기, D-139).
  void maybeLoadOlder() {
    if (_loadingOlder || !viewport.value.showsOldest || !hasMore) return;
    final id = ++_olderRun;
    HapticFeedback.lightImpact().ignore();
    setState(() => _loadingOlder = true);
    _busy.set(busy: true);
    _olderTimer = Timer(olderLoadTimeout, () => _finishOlder(id, failed: true));
    loadOlder()
        .then(
          (_) => _finishOlder(id, failed: false),
          onError: (Object _) => _finishOlder(id, failed: true),
        )
        .ignore();
  }

  void _finishOlder(int id, {required bool failed}) {
    if (id != _olderRun || !mounted) return;
    _olderRun++;
    _olderTimer?.cancel();
    setState(() => _loadingOlder = false);
    _busy.set(busy: false);
    if (failed) {
      final l10n = AppLocalizations.of(context);
      showFailedAlert(
        context,
        l10n.chartOlderFailedTitle,
        l10n.chartOlderFailedMessage,
      );
    }
  }

  /// 데이터가 바뀐 뒤(새로고침·이어 받기) 부른다. [shift]는 앞에 붙은 날짜 수(0 이하면 붙지 않음).
  /// 과거가 앞에 붙었으면 보던 날짜 범위를 그대로 둔다(D-104).
  void dataChanged(int shift) {
    final count = barCount;
    if (gesture == null) {
      viewport.value = periodView;
    } else if (shift > 0) {
      viewport.value = viewport.value.prepended(shift);
    } else {
      viewport.value = ChartViewport(
        count: count,
        start: viewport.value.start,
        span: viewport.value.span,
      ).clamped();
    }
    final i = crosshair.value;
    if (i != null) {
      crosshair.value = shift > 0 && i + shift < count ? i + shift : null;
    }
  }

  /// 기간의 최근 위치.
  ChartViewport get periodView => ChartViewport.latest(barCount, period.bars);

  void selectPeriod(ChartPeriod next) {
    setState(() {
      period = next;
      gesture = null;
    });
    viewport.value = periodView;
    crosshair.value = null;
  }

  void resetView() {
    setState(() => gesture = null);
    viewport.value = periodView;
    crosshair.value = null;
  }

  /// 끌어서 기간의 최근 위치로 돌아오면 [↻]를 거두고 선택 표시를 되살린다.
  /// 한 번 핀치하면 이후 드래그해도 선택 표시를 되살리지 않는다.
  void onGesture(ChartGesture g) {
    final back = _sameView(viewport.value, periodView);
    final next = back
        ? null
        : (gesture == ChartGesture.zoom ? ChartGesture.zoom : g);
    if (next != gesture) setState(() => gesture = next);
  }

  static bool _sameView(ChartViewport a, ChartViewport b) =>
      a.count == b.count &&
      (a.start - b.start).abs() < 1e-6 &&
      (a.span - b.span).abs() < 1e-6;

  /// 차트 Stack 위에 겹치는 공통 층: 이전 3년 로딩 표시(왼쪽 가운데), [↻](x축 라벨 바로 위 가운데).
  /// [yAxis]는 우측 y축 라벨 자리 너비다.
  List<Widget> chartOverlays({required double yAxis}) => [
    if (_loadingOlder)
      const Positioned.fill(
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: AppSpacing.lg),
              child: OlderIndicator(),
            ),
          ),
        ),
      ),
    if (gesture != null)
      Positioned(
        left: 0,
        right: yAxis,
        bottom: xLabelHeight + AppSpacing.sm,
        child: Center(child: ChartResetButton(onPressed: resetView)),
      ),
  ];

  /// 차트 아래 기간 칩. 가로 모드에서는 차트만 남긴다(D-103).
  Widget? periodChips(BuildContext context) {
    if (isLandscape(context)) return null;
    return ValueListenableBuilder(
      valueListenable: viewport,
      builder: (context, v, _) => PeriodChips(
        selected: gesture == ChartGesture.zoom ? null : period,
        nearest: gesture == ChartGesture.zoom
            ? nearestPeriod(v.span, v.count)
            : null,
        onSelect: selectPeriod,
      ),
    );
  }
}

/// 이전 데이터가 앞에 붙은 날짜 수. [oldFirst]가 새 [dates]에 없거나 맨 앞이면 0 이하다.
int prependShift(String? oldFirst, List<String> dates) =>
    oldFirst == null ? -1 : dates.indexOf(oldFirst);

/// 탭 가운데 안내 문구(없는 원자재, 값 없음).
class TabMessage extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: AppFontSize.body,
        ),
      ),
    ),
  );
}

/// x축 월 라벨: 1월은 연도, 나머지는 월 이름(D-121).
String monthLabel(AppLocalizations l10n, int year, int month) =>
    month == 1 ? '$year' : l10n.chartMonth('$month');

/// 차트 위 정보 줄 한 줄 높이(글자 크기 배율 반영). 봉·선은 줄 수만큼 비켜 그린다(D-117).
double chartInfoLineHeight(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(AppFontSize.caption) * 1.4 +
    AppSpacing.xs * 2;

/// 이전 3년 받기 로딩 표시(RN `OlderDataIndicator`).
class OlderIndicator extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).loading,
    child: Container(
      key: const Key('older-loading'),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.overlay,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.text),
      ),
    ),
  );
}
