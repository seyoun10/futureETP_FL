import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'import_rules.dart';

// 응답 모델 소스(lib/core/api/models)는 Flutter를 import하지 않는다.
// freezed는 package:flutter/foundation.dart가 보이면 DiagnosticableTreeMixin을
// 섞은 코드를 만든다. 그 import를 넣고 다시 생성하지 않으면 커밋된 생성 파일이
// 소스와 어긋난다. 모델은 freezed_annotation이 내보내는 meta·collection만 쓴다.
void main() {
  test('응답 모델 소스는 package:flutter를 import하지 않는다', () {
    final problems = <String>[];
    final files = Directory('lib/core/api/models')
        .listSync()
        .whereType<File>()
        .where(
          (f) =>
              f.path.endsWith('.dart') &&
              !f.path.endsWith('.g.dart') &&
              !f.path.endsWith('.freezed.dart'),
        );
    for (final file in files) {
      for (final uri in directiveUris(file.readAsStringSync())) {
        if (uri.startsWith('package:flutter/')) {
          problems.add('${file.path}: $uri');
        }
      }
    }
    expect(problems, isEmpty, reason: problems.join('\n'));
  });
}
