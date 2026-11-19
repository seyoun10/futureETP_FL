import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'import_rules.dart';

void main() {
  group('violation', () {
    test('feature끼리 import는 위반', () {
      expect(violation('features/a/x.dart', '../b/y.dart'), isNotNull);
      expect(
        violation('features/a/x.dart', 'package:futureetp/features/b/y.dart'),
        isNotNull,
      );
    });

    test('같은 feature 안 import는 허용', () {
      expect(violation('features/a/x.dart', 'widgets/y.dart'), isNull);
    });

    test('core → features·app은 위반', () {
      expect(
        violation('core/api/x.dart', '../../features/a/y.dart'),
        isNotNull,
      );
      expect(
        violation('core/x.dart', 'package:futureetp/app/router.dart'),
        isNotNull,
      );
    });

    test('feature → app은 위반, feature → core는 허용', () {
      expect(
        violation('features/a/x.dart', '../../app/router.dart'),
        isNotNull,
      );
      expect(violation('features/a/x.dart', '../../core/api/y.dart'), isNull);
    });

    test('app·main은 어디든 import할 수 있다', () {
      expect(violation('app/router.dart', '../features/a/x.dart'), isNull);
      expect(violation('main.dart', 'app/app.dart'), isNull);
    });

    test('패키지 밖 import는 검사하지 않는다', () {
      expect(violation('core/x.dart', 'package:dio/dio.dart'), isNull);
      expect(violation('core/x.dart', 'dart:async'), isNull);
    });
  });

  test('directiveUris는 import·export만 뽑는다', () {
    const src = '''
import 'a.dart';
export "b.dart" show B;
// import 'c.dart';
part 'd.g.dart';
''';
    expect(directiveUris(src), ['a.dart', 'b.dart']);
  });

  test('lib/ 전체가 import 방향 규칙을 지킨다', () {
    final problems = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final file in files) {
      final libPath = p.posix.joinAll(
        p.split(p.relative(file.path, from: 'lib')),
      );
      for (final uri in directiveUris(file.readAsStringSync())) {
        final reason = violation(libPath, uri);
        if (reason != null) problems.add('lib/$libPath: $uri ($reason)');
      }
    }
    expect(problems, isEmpty, reason: problems.join('\n'));
  });
}
