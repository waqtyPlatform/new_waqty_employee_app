import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/services/login_api_end_points.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_response_model.dart';

class LoginService {
  ApiConsumer apiConsumer;

  LoginService({required this.apiConsumer});

  Future<LoginResponseModel> login(LoginRequestModel parameter) async {
    final response = await apiConsumer.post(
      LoginApiEndPoints.login,
      LoginRequestModel(
        email: parameter.email,
        password: parameter.password,
      ).toJson(),
      _headers(),
    );
    final body = _decodeBody(response.body);
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final loginResponse = LoginResponseModel.fromJson(body);
      if (loginResponse.token.isEmpty) {
        throw ServerException(
          serverFailure: ServerFailure(
            message: _errorMessage(body, response.body),
          ),
        );
      }
      return loginResponse;
    } else {
      debugPrint('Login failed with status: ${response.statusCode}');
      debugPrint('Login failed body: ${response.body}');
      throw ServerException(
        serverFailure: ServerFailure(
          message: _errorMessage(body, response.body),
        ),
      );
    }
  }

  Map<String, String> _headers() {
    return {
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
      ConstantKeys.acceptLanguage: 'ar',
    };
  }

  Map<String, dynamic> _decodeBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return <String, dynamic>{};
  }

  String _errorMessage(Map<String, dynamic> body, String rawBody) {
    final message = body['message']?.toString();
    if (message?.isNotEmpty == true) return message!;

    final error = body['error']?.toString();
    if (error?.isNotEmpty == true) return error!;

    final data = body['data'];
    if (data is Map) {
      final dataMessage = data['message']?.toString();
      if (dataMessage?.isNotEmpty == true) return dataMessage!;
    }

    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstValue = errors.values.first;
      if (firstValue is List && firstValue.isNotEmpty) {
        return firstValue.first.toString();
      }
      return firstValue.toString();
    }
    if (errors is List && errors.isNotEmpty) {
      return errors.first.toString();
    }

    if (rawBody.trim().isNotEmpty && !rawBody.trimLeft().startsWith('<')) {
      return rawBody;
    }

    return 'Server error';
  }
}
