import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/models/notification_setting_response_model.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/services/notification_setting_api_end_points.dart';

class NotificationSettingService {
  final ApiConsumer apiConsumer;

  NotificationSettingService({required this.apiConsumer});

  Future<NotificationSettingResponseModel> getNotificationSettings(
    String languageCode,
  ) async {
    final response = await apiConsumer.get(
      NotificationSettingApiEndPoints.notificationSettings,
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok) {
      return NotificationSettingResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<NotificationSettingResponseModel> updateNotificationSettings({
    required Map<String, dynamic> body,
    required String languageCode,
  }) async {
    final response = await apiConsumer.patch(
      NotificationSettingApiEndPoints.notificationSettings,
      body,
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return NotificationSettingResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<Map<String, String>> _headers(String languageCode) async {
    return {
      ConstantKeys.appAuthorization:
          '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
      ConstantKeys.acceptLanguage: languageCode,
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }
}
