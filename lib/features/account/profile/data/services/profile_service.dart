import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_api_end_points.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';

class ProfileService {
  ApiConsumer apiConsumer;

  ProfileService({required this.apiConsumer});

  Future<ProfileResponseModel> getProfile() async {
    final response = await apiConsumer.get(
      ProfileApiEndPoints.getProfile,
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok) {
      return ProfileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<bool> checkCurrentAttendance() async {
    final response = await apiConsumer.get(
      ProfileApiEndPoints.currentAttendance,
      await _headers(),
    );

    if (response.statusCode != StatusCode.ok) {
      return false;
    }

    final responseBody = jsonDecode(response.body);
    if (responseBody is Map<String, dynamic>) {
      return responseBody['success'] == true;
    }
    return false;
  }

  Future<Map<String, String>> _headers() async {
    return {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }
}
