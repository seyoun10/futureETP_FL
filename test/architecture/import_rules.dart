// lib/ 안 import 방향 규칙(architecture.md "규칙", futureETP D-041).
// - feature끼리 import 금지
// - core는 features·app을 import 금지
// - features는 app(라우트)을 import 금지
import 'package:path/path.dart' as p;

const _package = 'futureetp';

/// lib 기준 경로(`features/a/x.dart`)의 계층 이름. feature는 `feature:<이름>`.
String layerOf(String libPath) {
  final parts = p.posix.split(libPath);
  if (parts.length > 2 && parts.first == 'features') {
    return 'feature:${parts[1]}';
  }
  if (parts.length > 1 && (parts.first == 'core' || parts.first == 'app')) {
    return parts.first;
  }
  return 'root';
}

/// import·export URI를 lib 기준 경로로 바꾼다. 이 패키지 밖(dart:, 다른 package:)이면 null.
String? resolveImport(String fromLibPath, String uri) {
  if (uri.startsWith('package:$_package/')) {
    return uri.substring('package:$_package/'.length);
  }
  if (uri.contains(':')) return null;
  return p.posix.normalize(p.posix.join(p.posix.dirname(fromLibPath), uri));
}

/// 규칙 위반이면 이유, 아니면 null.
String? violation(String fromLibPath, String uri) {
  final target = resolveImport(fromLibPath, uri);
  if (target == null) return null;
  final from = layerOf(fromLibPath);
  final to = layerOf(target);
  if (from == 'core' && (to == 'app' || to.startsWith('feature:'))) {
    return 'core는 $to를 import하지 않는다';
  }
  if (from.startsWith('feature:') && to == 'app') {
    return 'feature는 app(라우트)을 import하지 않는다';
  }
  if (from.startsWith('feature:') && to.startsWith('feature:') && from != to) {
    return 'feature끼리 import하지 않는다($from → $to)';
  }
  return null;
}

final _directive = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

/// 소스에서 import·export URI만 뽑는다.
Iterable<String> directiveUris(String source) =>
    _directive.allMatches(source).map((m) => m.group(1)!);
