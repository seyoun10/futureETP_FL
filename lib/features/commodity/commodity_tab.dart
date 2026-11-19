/// C 원자재 화면 하단 탭. 순서는 이격도차트 / 월물차트 / 월물커브 / ETP(D-111).
enum CommodityTab {
  disparity(''),
  contracts('contracts'),
  curve('curve'),
  etps('etps');

  new(this.segment);

  /// `/commodity/:code` 뒤 경로 조각. 이격도차트는 C 기본 탭이라 없다.
  final String segment;

  /// 이 탭의 위치.
  String location(String code) =>
      segment.isEmpty ? '/commodity/$code' : '/commodity/$code/$segment';

  /// 차트 탭(C-a~C-c)만 가로로 돌릴 수 있다.
  bool get isChart => this != etps;
}
