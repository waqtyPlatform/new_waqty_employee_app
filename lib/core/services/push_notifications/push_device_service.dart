import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:new_waqty_employee_app/core/api/end_points.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/my_app.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PushDeviceService {
  final FlutterSecureStorage _secureStorage;
  final http.Client _client;

  static const _deviceIdKey = 'PUSH_DEVICE_ID';
  static const _deviceTokenPath = '/api/employee/device-token';
  static const _logoutPath = '/api/employee/auth/logout';

  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _initialized = false;

  PushDeviceService(this._secureStorage, this._client);

  Future<void> initialize() async {
    if (_initialized || !_isMobile) return;
    _initialized = true;
    unawaited(registerCurrentDevice());
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen((_) {
          unawaited(registerCurrentDevice());
        });
  }

  Future<Map<String, dynamic>> buildDevicePayload({
    bool includeToken = true,
  }) async {
    if (!_isMobile) return <String, dynamic>{};

    final payload = <String, dynamic>{
      'device_id': await _deviceId(),
      'platform': _platform,
      'app_version': await _appVersion(),
    };

    if (includeToken) {
      final token = await _fcmToken();
      if (token != null && token.isNotEmpty) {
        payload['fcm_token'] = token;
      }
    }

    return payload;
  }

  Future<void> registerCurrentDevice() async {
    if (!_isMobile) return;
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (token.isEmpty) return;

    final payload = await buildDevicePayload();
    if (payload['fcm_token'] == null) return;

    await _postAuthenticated(
      path: _deviceTokenPath,
      token: token,
      payload: payload,
    );
  }

  Future<void> detachCurrentDevice(String token) async {
    if (!_isMobile || token.isEmpty) return;
    final payload = await buildDevicePayload();
    await _postAuthenticated(path: _logoutPath, token: token, payload: payload);
  }

  Future<void> _postAuthenticated({
    required String path,
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    try {
      await _client
          .post(
            Uri.parse('${EndPoints.baseUrl}$path'),
            headers: {
              ConstantKeys.contentType: ConstantKeys.applicationJson,
              ConstantKeys.acceptText: ConstantKeys.applicationJson,
              ConstantKeys.acceptLanguage: _languageCode(),
              ConstantKeys.appAuthorization: '${ConstantKeys.appBearer} $token',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  Future<String?> _fcmToken() async {
    try {
      final settings = await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true)
          .timeout(const Duration(seconds: 5));
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return null;
      }
      return await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 5),
      );
    } catch (_) {
      return null;
    }
  }

  Future<String> _deviceId() async {
    final existing = await _secureStorage.read(key: _deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final value = List<int>.generate(
      16,
      (_) => random.nextInt(256),
    ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    await _secureStorage.write(key: _deviceIdKey, value: value);
    return value;
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

  String _languageCode() {
    final context = navigatorKey.currentContext;
    return context?.locale.languageCode == 'en' ? 'en' : 'ar';
  }

  String get _platform {
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }

  bool get _isMobile {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
  }
}
