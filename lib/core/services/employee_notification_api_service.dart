import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:new_waqty_employee_app/core/api/end_points.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/my_app.dart';

class EmployeeNotificationApiService {
  final http.Client _client;

  EmployeeNotificationApiService(this._client);

  Future<http.Response?> registerDeviceToken({
    required String token,
    required Map<String, dynamic> payload,
  }) {
    return _postAuthenticated(
      endpoint: EndPoints.employeeDeviceToken,
      token: token,
      payload: payload,
    );
  }

  Future<http.Response?> logoutDevice({
    required String token,
    required Map<String, dynamic> payload,
  }) {
    return _postAuthenticated(
      endpoint: EndPoints.employeeAuthLogout,
      token: token,
      payload: payload,
    );
  }

  Future<String?> refreshToken({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _postAuthenticated(
        endpoint: EndPoints.employeeAuthRefresh,
        token: token,
        payload: payload,
      );
      if (response?.statusCode != 200) return null;

      final decoded = jsonDecode(response!.body);
      if (decoded is! Map) return null;
      final data = decoded['data'];
      if (data is! Map) return null;
      final refreshedToken = data['token']?.toString();
      if (refreshedToken == null || refreshedToken.isEmpty) return null;

      await CacheHelper.setSecuredString(
        ConstantKeys.saveTokenToShared,
        refreshedToken,
      );
      final expiresIn = int.tryParse(data['expires_in']?.toString() ?? '');
      if (expiresIn != null && expiresIn > 0) {
        final expiresAt = DateTime.now()
            .add(Duration(seconds: expiresIn))
            .millisecondsSinceEpoch
            .toString();
        await CacheHelper.setSecuredString(
          ConstantKeys.saveTokenExpiresAtToShared,
          expiresAt,
        );
      }

      return refreshedToken;
    } catch (_) {
      return null;
    }
  }

  Future<http.Response?> _postAuthenticated({
    required String endpoint,
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    try {
      return await _client
          .post(
            Uri.parse(endpoint),
            headers: {
              ConstantKeys.contentType: ConstantKeys.applicationJson,
              ConstantKeys.acceptText: ConstantKeys.applicationJson,
              ConstantKeys.acceptLanguage: _languageCode(),
              ConstantKeys.appAuthorization: '${ConstantKeys.appBearer} $token',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  String _languageCode() {
    final context = navigatorKey.currentContext;
    return context?.locale.languageCode == 'en' ? 'en' : 'ar';
  }
}
