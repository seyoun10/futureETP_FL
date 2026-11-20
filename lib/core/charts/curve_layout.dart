import 'dart:math' as math;

// C-b 커브 차트 좌표 계산(RN `curveLayout.ts`). 모두 순수 함수다.

/// 라벨이 겹치지 않게 몇 개마다 하나씩 그릴지(1 = 모두).
int labelStride(double slotWidth, double labelWidth) =>
    slotWidth <= 0 ? 1 : math.max(1, (labelWidth / slotWidth).ceil());

/// x에 가장 가까운 칸 순번. 그림 영역 밖이면 양끝 칸(십자선을 끌 때). 칸이 없으면 null.
int? nearestSlot(double x, double left, double slotWidth, int count) {
  if (slotWidth <= 0 || count == 0) return null;
  return ((x - left) / slotWidth).floor().clamp(0, count - 1);
}

/// 커브 선분 하나.
typedef Segment = ({double x0, double y0, double x1, double y1});

/// 선분이 `left`~`right` × `top`~`bottom` 상자를 지나는지.
bool segmentHitsBox(
  Segment s,
  double left,
  double right,
  double top,
  double bottom,
) {
  final a = math.max(math.min(s.x0, s.x1), left);
  final b = math.min(math.max(s.x0, s.x1), right);
  if (a > b) return false;
  double at(double x) =>
      s.x1 == s.x0 ? s.y0 : s.y0 + (s.y1 - s.y0) * (x - s.x0) / (s.x1 - s.x0);
  final (y0, y1) = s.x1 == s.x0 ? (s.y0, s.y1) : (at(a), at(b));
  return math.max(y0, y1) >= top && math.min(y0, y1) <= bottom;
}

/// 점 위 변화율 라벨 하나. `x`는 글자 왼쪽(점 가운데 기준), `anchor`는 점 x,
/// `top`·`bottom`은 그 칸 점들의 가장 위·아래 y. `below`면 점 아래에 둔다(하락).
typedef PctLabelInput = ({
  double x,
  double anchor,
  double width,
  double top,
  double bottom,
  bool below,
});

/// 변화율 라벨을 모두 그리되 겹치지 않게 놓을 글자 왼쪽 x와 기준선(아래 끝) y(D-118, D-122, D-123).
///
/// 오르면 점 위, 내리면(`below`) 점 아래에만 둔다. 앞 라벨부터 놓고, 이미 놓은 라벨과 겹치면
/// 그 라벨 바깥(위쪽 라벨은 더 위, 아래쪽 라벨은 더 아래)으로 밀어낸다. 밀려서 [minY]~[maxY]를 벗어나면
/// 그 끝에 붙인다. 그 높이에서 선과 겹치면 좌우로 가장 덜 밀어 선·라벨과 겹치지 않는 자리로 옮긴다.
/// 점 x가 글자 폭 안에 남고 [minX]~[maxX]를 넘지 않는 만큼만 밀고, 그런 자리가 없으면 그대로 둔다.
List<({double x, double y})> placePctLabels(
  List<PctLabelInput> labels, {
  required double height,
  required double gap,
  required double minY,
  required double maxY,
  double minX = double.negativeInfinity,
  double maxX = double.infinity,
  List<Segment> segments = const [],
}) {
  final placed = <({double left, double right, double y})>[];
  ({double left, double right, double y})? hitsLabel(
    double x,
    double width,
    double y,
  ) {
    for (final p in placed) {
      if (x < p.right + gap &&
          p.left < x + width + gap &&
          y > p.y - height &&
          p.y > y - height) {
        return p;
      }
    }
    return null;
  }

  bool hitsLine(double x, double width, double y) =>
      segments.any((s) => segmentHitsBox(s, x, x + width, y - height, y));

  final out = <({double x, double y})>[];
  for (final l in labels) {
    var y = l.below ? l.bottom + gap + height : l.top - gap;
    // 밀 때마다 y가 한쪽으로만 움직여 놓은 라벨 수만큼 안에 끝난다
    for (
      var hit = hitsLabel(l.x, l.width, y);
      hit != null;
      hit = hitsLabel(l.x, l.width, y)
    ) {
      y = l.below ? hit.y + height + gap : hit.y - height - gap;
    }
    y = math.min(math.max(y, minY + height), maxY);
    var x = l.x;
    if (hitsLine(x, l.width, y)) {
      final lo = math.max(l.anchor - l.width, minX);
      final hi = math.min(l.anchor, maxX - l.width);
      // 1pt씩 오른쪽·왼쪽을 번갈아 본다
      search:
      for (var d = 1; l.x - d >= lo || l.x + d <= hi; d++) {
        for (final c in [l.x + d, l.x - d]) {
          if (c >= lo &&
              c <= hi &&
              !hitsLine(c, l.width, y) &&
              hitsLabel(c, l.width, y) == null) {
            x = c;
            break search;
          }
        }
      }
    }
    placed.add((left: x, right: x + l.width, y: y));
    out.add((x: x, y: y));
  }
  return out;
}
