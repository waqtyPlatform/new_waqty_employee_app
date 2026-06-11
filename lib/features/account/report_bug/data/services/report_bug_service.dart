import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/models/report_bug_response_model.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/services/report_bug_api_end_points.dart';

class ReportBugService {
  final ApiConsumer apiConsumer;

  ReportBugService({required this.apiConsumer});

  Future<ReportBugResponseModel> sendBugReport({
    required String category,
    required String description,
    required String stepsToReproduce,
    required String languageCode,
  }) async {
    final response = await apiConsumer.post(
      ReportBugApiEndPoints.sendBugReport,
      {
        'category': category,
        'description': description,
        'steps_to_reproduce': stepsToReproduce,
      },
      {
        ConstantKeys.appAuthorization:
            '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ReportBugResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
