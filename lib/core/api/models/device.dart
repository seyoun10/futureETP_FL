import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';

part 'device.freezed.dart';
part 'device.g.dart';

/// `PUT /v1/devices` 응답.
@freezed
abstract class Device with _$Device {
  const factory({required String id}) = _Device;

  factory fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}

/// `PUT /v1/devices` 본문(deviceRegistration.json, D-120). 모르는 필드는 서버가 거절한다.
@immutable
class DeviceRegistration {
  const new({
    required this.pushToken,
    required this.platform,
    required this.appVersion,
  });

  /// Android FCM 토큰, iOS APNs 기기 토큰. 없으면 null(D-037).
  final String? pushToken;
  final DevicePlatform platform;

  /// `fl-<버전>`(FL-002).
  final String? appVersion;

  Map<String, Object?> toJson() => {
    'pushToken': pushToken,
    'platform': platform.name.toUpperCase(),
    'appVersion': appVersion,
  };
}
