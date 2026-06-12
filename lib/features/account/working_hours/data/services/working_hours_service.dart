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
    final currentMonthRange = _CurrentMonthRange.now();
    final response = await apiConsumer.get(
      WorkingHoursApiEndPoints.getWorkingHours(
        page: page,
        dateFrom: currentMonthRange.dateFrom,
        dateTo: currentMonthRange.dateTo,
      ),
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
}

class _CurrentMonthRange {
  final String dateFrom;
  final String dateTo;

  _CurrentMonthRange({required this.dateFrom, required this.dateTo});

  factory _CurrentMonthRange.now() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month -1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    return _CurrentMonthRange(
      dateFrom: _formatDate(firstDay),
      dateTo: _formatDate(lastDay),
    );
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
