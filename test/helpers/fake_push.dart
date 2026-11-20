import 'dart:async';

import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/push/push_service.dart';

/// 기기 푸시 흉내. 호출을 기록하고 토큰·탭 이벤트를 테스트가 넣는다.
class FakePushService implements PushService {
  new({
    this.platform = DevicePlatform.android,
    this.token = 'fcm-token',
    this.tokenError,
    this.initialTap,
  });

  @override
  final DevicePlatform? platform;

  String? token;
  Exception? tokenError;
  PushData? initialTap;

  final channelNames = <Map<AndroidChannel, String>>[];
  int permissionRequests = 0;
  final tokenRefresh = StreamController<String>.broadcast();
  final taps = StreamController<PushData>.broadcast();

  @override
  Future<void> setupChannels(Map<AndroidChannel, String> names) async =>
      channelNames.add(names);

  @override
  Future<void> requestPermission() async => permissionRequests++;

  @override
  Future<String?> getToken() async {
    if (tokenError case final error?) throw error;
    return token;
  }

  @override
  Stream<String> get onTokenRefresh => tokenRefresh.stream;

  @override
  Future<PushData?> takeInitialTap() async {
    final data = initialTap;
    initialTap = null;
    return data;
  }

  @override
  Stream<PushData> get onTap => taps.stream;
}
