import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/services/employee_notification_api_service.dart';
import 'package:new_waqty_employee_app/core/services/local_notification_service.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_center_service.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_router_service.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/firebase_options.dart';
import 'package:new_waqty_employee_app/my_app.dart';
import 'package:package_info_plus/package_info_plus.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!_isSupportedNotificationPlatform) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotificationService.initializedNotification();
  await FirebaseNotificationService.showRemoteMessage(message);
}

class FirebaseNotificationService with WidgetsBindingObserver {
  final FlutterSecureStorage _secureStorage;
  final EmployeeNotificationApiService _notificationApiService;

  static const _deviceIdKey = 'PUSH_DEVICE_ID';

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _openedMessageSubscription;
  bool _initialized = false;
  bool _isLoggingOut = false;
  int _registrationGeneration = 0;
  Future<void> _languageSyncFuture = Future.value();
  String? _lastSyncedNotificationLanguage;
  String? _lastSyncedNotificationLanguageToken;

  FirebaseNotificationService(
    this._secureStorage,
    this._notificationApiService,
  );

  Future<void> initialize() async {
    if (_initialized || !_isSupportedNotificationPlatform) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    WidgetsBinding.instance.addObserver(this);
    await LocalNotificationService.initializedNotification();
    await _requestPermission();
    await _setForegroundPresentationOptions();

    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );
    _openedMessageSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpenedMessage,
    );

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      unawaited(_handleOpenedMessage(initialMessage));
    }

    unawaited(registerCurrentDevice());
    unawaited(syncNotificationLanguage());
    unawaited(getIt<NotificationCenterService>().refreshUnreadCount());
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen((_) {
          unawaited(registerCurrentDevice());
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(syncNotificationLanguage());
    }
  }

  Future<Map<String, dynamic>> buildDevicePayload({
    bool includeToken = true,
  }) async {
    if (!_isSupportedNotificationPlatform) return <String, dynamic>{};

    final payload = <String, dynamic>{
      'device_id': await _deviceId(),
      'platform': _platform,
    };
    final appVersion = await _appVersion();
    if (appVersion != null && appVersion.isNotEmpty) {
      payload['app_version'] = appVersion;
    }

    if (includeToken) {
      final token = await getCurrentFcmToken();
      if (token != null && token.isNotEmpty) {
        payload['fcm_token'] = token;
      }
    }

    return payload;
  }

  Future<void> registerCurrentDevice() async {
    if (!_isSupportedNotificationPlatform || _isLoggingOut) return;
    final generation = _registrationGeneration;
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (token.isEmpty) return;

    final payload = await buildDevicePayload();
    if (payload['fcm_token'] == null) return;
    if (_isLoggingOut || generation != _registrationGeneration) return;
    await syncNotificationLanguage();

    final latestToken = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (latestToken != token) return;

    var response = await _notificationApiService.registerDeviceToken(
      token: token,
      payload: payload,
    );
    if (response?.statusCode == 401) {
      final refreshedToken = await _notificationApiService.refreshToken(
        token: token,
        payload: payload,
      );
      if (refreshedToken != null && refreshedToken.isNotEmpty) {
        response = await _notificationApiService.registerDeviceToken(
          token: refreshedToken,
          payload: payload,
        );
      }
    }
    await getIt<NotificationCenterService>().refreshUnreadCount();
  }

  Future<void> syncNotificationLanguage({
    String? languageCode,
    bool force = false,
  }) async {
    if (!_isSupportedNotificationPlatform || _isLoggingOut) return;

    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (token.isEmpty) return;

    final language = _normalizeNotificationLanguage(
      languageCode ?? _notificationLanguageCode(),
    );
    if (!force &&
        _lastSyncedNotificationLanguage == language &&
        _lastSyncedNotificationLanguageToken == token) {
      return;
    }

    final generation = _registrationGeneration;
    _languageSyncFuture = _languageSyncFuture.then((_) async {
      if (_isLoggingOut || generation != _registrationGeneration) return;

      final latestToken = await CacheHelper.getSecuredString(
        ConstantKeys.saveTokenToShared,
      );
      if (latestToken.isEmpty || latestToken != token) return;

      var response = await _notificationApiService.updateNotificationLanguage(
        token: token,
        language: language,
      );
      if (response?.statusCode == 401) {
        final refreshedToken = await _notificationApiService.refreshToken(
          token: token,
          payload: await buildDevicePayload(),
        );
        if (refreshedToken != null && refreshedToken.isNotEmpty) {
          response = await _notificationApiService.updateNotificationLanguage(
            token: refreshedToken,
            language: language,
          );
        }
      }
      if (response?.statusCode == 200) {
        _lastSyncedNotificationLanguage = language;
        _lastSyncedNotificationLanguageToken =
            await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared);
      }
    });

    return _languageSyncFuture;
  }

  Future<bool> detachCurrentDevice(String token) async {
    if (!_isSupportedNotificationPlatform || token.isEmpty) return false;
    _isLoggingOut = true;
    _registrationGeneration++;
    try {
      final payload = await _logoutPayload();
      var response = await _notificationApiService.logoutDevice(
        token: token,
        payload: payload,
      );
      if (response?.statusCode == 401) {
        final refreshedToken = await _notificationApiService.refreshToken(
          token: token,
          payload: await buildDevicePayload(),
        );
        if (refreshedToken != null && refreshedToken.isNotEmpty) {
          response = await _notificationApiService.logoutDevice(
            token: refreshedToken,
            payload: payload,
          );
        }
      }
      return response?.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void completeLocalLogout() {
    _registrationGeneration++;
    _isLoggingOut = false;
    _lastSyncedNotificationLanguage = null;
    _lastSyncedNotificationLanguageToken = null;
    getIt<NotificationCenterService>().clearAccountState();
    getIt<NotificationRouterService>().clearAccountState();
  }

  Future<String?> getCurrentFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 5),
      );
      if (token == null || token.length > 255) return null;
      return token;
    } catch (_) {
      return null;
    }
  }

  static Future<void> showRemoteMessage(RemoteMessage message) async {
    if (!_shouldShowLocalRemoteMessage) return;

    final title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        message.data['notification_title']?.toString() ??
        '';
    final body =
        message.notification?.body ??
        message.data['body']?.toString() ??
        message.data['notification_body']?.toString() ??
        '';
    await LocalNotificationService.showNotification(
      title: title,
      body: body,
      payload: message.data,
    );
  }

  Future<void> _requestPermission() async {
    try {
      await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true)
          .timeout(const Duration(seconds: 5));
    } catch (_) {}
  }

  Future<void> _setForegroundPresentationOptions() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (_) {}
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    getIt<NotificationCenterService>().notifyInboxShouldRefresh();
    unawaited(getIt<NotificationCenterService>().refreshUnreadCount());

    // On iOS, notification payloads are presented by Firebase using the
    // foreground presentation options above. Showing a local notification as
    // well would display the same notification twice. Data-only messages still
    // need a local notification because iOS has no alert to present for them.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        message.notification != null) {
      return;
    }
    await showRemoteMessage(message);
  }

  Future<void> _handleOpenedMessage(RemoteMessage message) async {
    await getIt<NotificationRouterService>().handlePayload(message.data);
  }

  Future<Map<String, dynamic>> _logoutPayload() async {
    final token = await getCurrentFcmToken();
    if (token == null || token.isEmpty) return <String, dynamic>{};
    return {'fcm_token': token};
  }

  Future<String> _deviceId() async {
    final existing = await _secureStorage.read(key: _deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final value = _newUuidV4();
    await _secureStorage.write(key: _deviceIdKey, value: value);
    return value;
  }

  String _newUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  Future<String?> _appVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final build = info.buildNumber.isEmpty ? '' : '+${info.buildNumber}';
      final version = '${info.version}$build';
      if (version.length <= 30) return version;
      return info.version.length <= 30 ? info.version : null;
    } catch (_) {
      return null;
    }
  }

  String _notificationLanguageCode() {
    final context = navigatorKey.currentContext;
    return context?.locale.languageCode == 'en' ? 'en' : 'ar';
  }

  String _normalizeNotificationLanguage(String languageCode) {
    return languageCode == 'en' ? 'en' : 'ar';
  }

  String get _platform {
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tokenRefreshSubscription?.cancel();
    _foregroundMessageSubscription?.cancel();
    _openedMessageSubscription?.cancel();
  }
}

bool get _isSupportedNotificationPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

bool get _shouldShowLocalRemoteMessage {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}
