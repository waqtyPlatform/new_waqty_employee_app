import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/app_interceptor.dart';
import 'package:new_waqty_employee_app/core/api/end_points.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/services/firebase_notification_service.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/my_app.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class HttpConsumer implements ApiConsumer {
  final http.Client _rawClient;
  http.Client _client;
  Future<_RefreshTokenResult>? _refreshTokenFuture;

  HttpConsumer(this._rawClient) : _client = _rawClient {
    _client = InterceptedClient.build(interceptors: [getIt<AppInterceptor>()]);
  }

  @override
  Future<http.Response> get(String path, Map<String, String>? headers) async {
    return _sendWithRefresh(
      headers: headers,
      request: (requestHeaders) =>
          _client.get(Uri.parse(path), headers: requestHeaders),
    );
  }

  @override
  Future<http.Response> put(
    String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    return _sendWithRefresh(
      headers: headers,
      request: (requestHeaders) => _client.put(
        Uri.parse(path),
        body: json.encode(body),
        headers: requestHeaders,
      ),
    );
  }

  @override
  Future<http.Response> patch(
    String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    return _sendWithRefresh(
      headers: headers,
      request: (requestHeaders) => _client.patch(
        Uri.parse(path),
        body: json.encode(body),
        headers: requestHeaders,
      ),
    );
  }

  @override
  Future<http.Response> post(
    String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    return _sendWithRefresh(
      headers: headers,
      request: (requestHeaders) => _client.post(
        Uri.parse(path),
        body: json.encode(body),
        headers: requestHeaders,
      ),
    );
  }

  @override
  Future<http.Response> delete(
    String path,
    Map<String, String>? headers,
  ) async {
    return _sendWithRefresh(
      headers: headers,
      request: (requestHeaders) =>
          _client.delete(Uri.parse(path), headers: requestHeaders),
    );
  }

  @override
  Future<http.Response> multiPost(
    String path,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    return _sendWithRefresh(
      headers: headers,
      includeContentType: false,
      request: (requestHeaders) =>
          _sendMultipart(path: path, body: body, headers: requestHeaders),
    );
  }

  Future<http.Response> _sendMultipart({
    required String path,
    required Map<String, dynamic> body,
    required Map<String, String>? headers,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(path));
    if (headers != null) {
      request.headers.addAll(headers);
    }
    body.forEach((key, value) async {
      if (key == "images") {
        for (var item in value as List<String>) {
          request.files.add(
            await http.MultipartFile.fromPath(key, item.toString()),
          );
        }
      } else if (key == "img") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else if (key == "image") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else if (key == "logo") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      }
    });
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<http.Response> _sendWithRefresh({
    required Map<String, String>? headers,
    required Future<http.Response> Function(Map<String, String>? headers)
    request,
    bool includeContentType = true,
  }) async {
    final defaultHeaders = _headersWithDefaults(
      headers,
      includeContentType: includeContentType,
    );
    final preparedHeaders = await _headersAfterPreemptiveRefresh(
      defaultHeaders,
    );
    final response = await request(preparedHeaders);
    if (response.statusCode != 401) {
      return response;
    }

    final oldToken = _tokenFromHeaders(preparedHeaders);
    if (oldToken.isEmpty) {
      await _clearSessionAndOpenLogin();
      return response;
    }

    final storedToken = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (storedToken.isNotEmpty && storedToken != oldToken) {
      return request(_headersWithToken(preparedHeaders, storedToken));
    }

    final refreshResult = await _refreshToken(oldToken, preparedHeaders);
    if (refreshResult == _RefreshTokenResult.sessionExpired) {
      await _clearSessionAndOpenLogin();
      return response;
    }
    if (refreshResult != _RefreshTokenResult.success) return response;

    final newToken = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    return request(_headersWithToken(preparedHeaders, newToken));
  }

  Future<_RefreshTokenResult> _refreshToken(
    String currentToken,
    Map<String, String>? failedRequestHeaders,
  ) {
    _refreshTokenFuture ??= _runRefreshToken(currentToken, failedRequestHeaders)
        .whenComplete(() {
          _refreshTokenFuture = null;
        });
    return _refreshTokenFuture!;
  }

  Future<_RefreshTokenResult> _runRefreshToken(
    String currentToken,
    Map<String, String>? failedRequestHeaders,
  ) async {
    final language =
        failedRequestHeaders?[ConstantKeys.acceptLanguage] ??
        _fallbackLanguageCode();
    final response = await _rawClient.post(
      Uri.parse(EndPoints.employeeAuthRefresh),
      headers: {
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
        ConstantKeys.acceptLanguage: language,
        ConstantKeys.appAuthorization:
            '${ConstantKeys.appBearer} $currentToken',
      },
      body: jsonEncode(
        await getIt<FirebaseNotificationService>().buildDevicePayload(),
      ),
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      _showRefreshErrorMessage(response.body);
      return _RefreshTokenResult.sessionExpired;
    }

    if (response.statusCode != StatusCode.ok) {
      return _RefreshTokenResult.failed;
    }

    final body = jsonDecode(response.body);
    String? token;
    int? expiresIn;
    if (body is Map) {
      final data = body['data'];
      if (data is Map) {
        token = data['token']?.toString();
        expiresIn = int.tryParse(data['expires_in']?.toString() ?? '');
      }
    }
    if (token == null || token.isEmpty) {
      return _RefreshTokenResult.failed;
    }

    await CacheHelper.setSecuredString(ConstantKeys.saveTokenToShared, token);
    if (expiresIn != null && expiresIn > 0) {
      await _storeTokenExpiresAt(expiresIn);
    }
    final notificationService = getIt<FirebaseNotificationService>();
    await notificationService.syncNotificationLanguage(force: true);
    await notificationService.registerCurrentDevice();
    return _RefreshTokenResult.success;
  }

  Future<Map<String, String>?> _headersAfterPreemptiveRefresh(
    Map<String, String>? headers,
  ) async {
    final token = _tokenFromHeaders(headers);
    if (token.isEmpty || !await _shouldRefreshTokenSoon()) {
      return headers;
    }

    final refreshResult = await _refreshToken(token, headers);
    if (refreshResult == _RefreshTokenResult.sessionExpired) {
      await _clearSessionAndOpenLogin();
      return headers;
    }
    if (refreshResult != _RefreshTokenResult.success) return headers;

    final newToken = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    return _headersWithToken(headers, newToken);
  }

  Future<bool> _shouldRefreshTokenSoon() async {
    final expiresAtValue = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenExpiresAtToShared,
    );
    final expiresAt = int.tryParse(expiresAtValue);
    if (expiresAt == null || expiresAt == 0) return false;

    final refreshBeforeMs = const Duration(minutes: 2).inMilliseconds;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now >= expiresAt - refreshBeforeMs;
  }

  Future<void> _storeTokenExpiresAt(int expiresInSeconds) async {
    final expiresAt = DateTime.now()
        .add(Duration(seconds: expiresInSeconds))
        .millisecondsSinceEpoch
        .toString();
    await CacheHelper.setSecuredString(
      ConstantKeys.saveTokenExpiresAtToShared,
      expiresAt,
    );
  }

  String _tokenFromHeaders(Map<String, String>? headers) {
    final authorization = headers?[ConstantKeys.appAuthorization] ?? '';
    final prefix = '${ConstantKeys.appBearer} ';
    if (!authorization.startsWith(prefix)) return '';
    return authorization.substring(prefix.length).trim();
  }

  Map<String, String> _headersWithToken(
    Map<String, String>? headers,
    String token,
  ) {
    final retryHeaders = Map<String, String>.from(headers ?? {});
    retryHeaders[ConstantKeys.appAuthorization] =
        '${ConstantKeys.appBearer} $token';
    return retryHeaders;
  }

  Map<String, String> _headersWithDefaults(
    Map<String, String>? headers, {
    required bool includeContentType,
  }) {
    final defaultHeaders = Map<String, String>.from(headers ?? {});
    if (includeContentType) {
      defaultHeaders[ConstantKeys.contentType] = ConstantKeys.applicationJson;
    }
    defaultHeaders[ConstantKeys.acceptText] = ConstantKeys.applicationJson;
    defaultHeaders[ConstantKeys.acceptLanguage] = _currentLanguageCode();
    return defaultHeaders;
  }

  String _currentLanguageCode() {
    final context = navigatorKey.currentContext;
    return context?.locale.languageCode == 'en' ? 'en' : 'ar';
  }

  String _fallbackLanguageCode() {
    return _currentLanguageCode();
  }

  Future<void> _clearSessionAndOpenLogin() async {
    await CacheHelper.removeSecureData(ConstantKeys.saveTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveTokenExpiresAtToShared);
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.loginScreen,
      (route) => false,
    );
  }

  void _showRefreshErrorMessage(String responseBody) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    try {
      final body = jsonDecode(responseBody);
      final message = body is Map ? body['message']?.toString() : null;
      if (message?.isNotEmpty == true) {
        AppConstant.toast(message!, false, context);
      }
    } catch (_) {}
  }
}

enum _RefreshTokenResult { success, failed, sessionExpired }
