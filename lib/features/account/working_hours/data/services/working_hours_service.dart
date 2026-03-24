import 'dart:convert';
import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/services/working_hours_api_end_points.dart';

class WorkingHoursService {
  ApiConsumer apiConsumer;

  WorkingHoursService({required this.apiConsumer});

  Future<dynamic> getWorkingHours(int page) async {
    final response = await apiConsumer.get(
      WorkingHoursApiEndPoints.getWorkingHours(page),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return jsonDecode(response.body);
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
