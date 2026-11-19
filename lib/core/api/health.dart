import 'package:flutter/foundation.dart';

/// `GET /v1/health`의 data(contract/schemas/health.json).
@immutable
class Health {
  const new({required this.status, required this.commit});

  /// 스키마와 다르면 [FormatException]. 3단계에서 freezed 모델과 SCHEMA_MISMATCH로 바꾼다.
  factory fromJson(Object? json) {
    if (json case {'status': 'ok', 'commit': final String? commit}) {
      return Health(status: 'ok', commit: commit);
    }
    throw FormatException('health: unexpected data $json');
  }

  final String status;
  final String? commit;
}
