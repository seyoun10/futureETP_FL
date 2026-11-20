import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:material_ui/material_ui.dart';

/// 서버가 알림 `data`에 넣는 값(모두 문자열, FCM data 규칙).
typedef PushData = Map<String, Object?>;

/// 서버가 발송 때 지정하는 Android 채널(shared `ANDROID_CHANNELS`).
/// 운영 알림은 따로 끌 수 있게 나눈다(D-045).
enum AndroidChannel {
  alerts(Importance.high),
  ops(Importance.defaultImportance);

  new(this.importance);

  final Importance importance;
}

/// 푸시 기능의 기기 쪽 경계. 테스트는 가짜로 바꾼다.
abstract interface class PushService {
  /// 이 기기의 서버 등록 플랫폼. 푸시를 못 쓰는 플랫폼이면 null(등록하지 않는다).
  DevicePlatform? get platform;

  /// Android 채널을 만든다. 이미 있으면 이름만 바뀐다(중요도는 OS 설정이 우선).
  Future<void> setupChannels(Map<AndroidChannel, String> names);

  /// 권한이 없고 다시 물을 수 있으면 권한 창을 띄운다. 거부돼도 토큰은 받는다.
  Future<void> requestPermission();

  /// 네이티브 푸시 토큰(Android FCM). 실패하면 던진다.
  Future<String?> getToken();

  /// FCM이 토큰을 바꿀 때 새 토큰.
  Stream<String> get onTokenRefresh;

  /// 앱이 꺼져 있을 때 알림을 눌러 실행됐으면 그 알림 data. 한 번 읽으면 지운다.
  Future<PushData?> takeInitialTap();

  /// 앱이 켜져 있을 때(배경 포함) 누른 알림 data.
  Stream<PushData> get onTap;
}

/// 푸시를 쓰지 않는 플랫폼(Apple 가입 전 iOS, 테스트 기본값).
class NoPushService implements PushService {
  const new();

  @override
  DevicePlatform? get platform => null;

  @override
  Future<void> setupChannels(Map<AndroidChannel, String> names) async {}

  @override
  Future<void> requestPermission() async {}

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Future<PushData?> takeInitialTap() async => null;

  @override
  Stream<PushData> get onTap => const Stream.empty();
}

/// Android FCM(`firebase_messaging`) + 앱 사용 중 알림 표시
/// (`flutter_local_notifications`, D-037).
///
/// 서버는 notification 메시지에 채널을 지정해 보낸다(`fcmSender.ts`). 앱이 배경·종료 상태면
/// OS가 표시하고, 앱을 보고 있을 때는 FCM이 표시하지 않아 같은 채널로 직접 띄운다
/// (RN `setupForegroundNotifications`: 배너·목록·소리, 배지 없음).
class FirebasePushService implements PushService {
  new _(this._messaging, this._local);

  /// Firebase를 켜고 알림 리스너를 붙인다. `android/app/google-services.json`에서 설정을 읽는다.
  static Future<FirebasePushService> start() async {
    await Firebase.initializeApp();
    final service = FirebasePushService._(
      FirebaseMessaging.instance,
      FlutterLocalNotificationsPlugin(),
    );
    await service._init();
    return service;
  }

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;
  final _taps = StreamController<PushData>.broadcast();
  var _localId = 0;

  /// 채널 이름. 앱 사용 중 표시는 채널을 만든 뒤라 이름이 쓰이지 않지만 API가 요구한다.
  Map<AndroidChannel, String> _channelNames = const {};

  Future<void> _init() async {
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (_decode(response.payload) case final data?) _taps.add(data);
      },
    );
    FirebaseMessaging.onMessage.listen(
      (message) => unawaited(_showForeground(message)),
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _taps.add(message.data),
    );
  }

  Future<void> _showForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final channel =
        AndroidChannel.values.asNameMap()[notification.android?.channelId] ??
        AndroidChannel.alerts;
    try {
      await _local.show(
        id: _localId++,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.name,
            _channelNames[channel] ?? channel.name,
            importance: channel.importance,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    } on Object catch (error) {
      debugPrint('[push] foreground notification failed: $error');
    }
  }

  static PushData? _decode(String? payload) {
    if (payload == null) return null;
    try {
      return switch (jsonDecode(payload)) {
        final Map<String, Object?> data => data,
        _ => null,
      };
    } on FormatException {
      return null;
    }
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _local
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  DevicePlatform? get platform => DevicePlatform.android;

  @override
  Future<void> setupChannels(Map<AndroidChannel, String> names) async {
    _channelNames = names;
    for (final channel in AndroidChannel.values) {
      await _android?.createNotificationChannel(
        AndroidNotificationChannel(
          channel.name,
          names[channel] ?? channel.name,
          importance: channel.importance,
          showBadge: false,
        ),
      );
    }
  }

  @override
  Future<void> requestPermission() async {
    // Android 13+는 채널이 있어야 권한 창이 뜬다. 영구 거부면 창 없이 끝난다.
    await _messaging.requestPermission();
  }

  // firebase_messaging 17은 FID 등록(register·onRegistered)을 권하지만 서버는 FCM 등록 토큰을
  // `token`으로 보낸다(fcmSender.ts, RN getDevicePushTokenAsync와 같은 값). 서버가 바뀌기 전까지
  // 등록 토큰 API를 쓴다(FL-032).
  @override
  // 서버가 FID가 아닌 FCM 등록 토큰을 받는다(위 주석)
  // ignore: deprecated_member_use
  Future<String?> getToken() => _messaging.getToken();

  @override
  // 서버가 FID가 아닌 FCM 등록 토큰을 받는다(getToken 주석)
  // ignore: deprecated_member_use
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<PushData?> takeInitialTap() async {
    if (await _messaging.getInitialMessage() case final message?) {
      return message.data;
    }
    // 앱 사용 중 띄운 알림을 앱을 끈 뒤 눌렀을 때
    final launch = await _local.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      return _decode(launch?.notificationResponse?.payload);
    }
    return null;
  }

  @override
  Stream<PushData> get onTap => _taps.stream;
}

/// 기기 푸시. `main`이 플랫폼에 맞는 구현으로 덮어쓴다.
final pushServiceProvider = Provider<PushService>(
  (ref) => const NoPushService(),
);
