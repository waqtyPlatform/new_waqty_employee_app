import 'dart:convert';
import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/services/working_hours_api_end_points.dart';

class WorkingHoursService {
  ApiConsumer apiConsumer;

  WorkingHoursService({required this.apiConsumer});

  Future<WorkingHoursResponseModel> getWorkingHours({
    required int page,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      WorkingHoursApiEndPoints.getWorkingHours(page: page),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return WorkingHoursResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<WorkingHoursModel> getShiftDetails({
    required String shiftId,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      WorkingHoursApiEndPoints.getShiftDetails(shiftId),
      await _headers(languageCode),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == StatusCode.ok) {
      final data = body is Map ? body['data'] : null;
      if (data is Map) {
        return WorkingHoursModel.fromJson(Map<String, dynamic>.from(data));
      }
      throw ServerException(
        serverFailure: ServerFailure(message: 'Invalid server response'),
      );
    } else {
      throw ServerException(serverFailure: ServerFailure.fromJson(body));
    }
  }

  Future<Map<String, String>> _headers(String languageCode) async {
    return {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      ConstantKeys.acceptLanguage: languageCode,
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }
}
