import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/models/employee_package_model.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/services/employee_packages_api_end_points.dart';

class EmployeePackagesService {
  final ApiConsumer apiConsumer;

  EmployeePackagesService({required this.apiConsumer});

  Future<EmployeePackagesResponseModel> getPackages({
    required String languageCode,
    required int page,
    int perPage = 15,
    String search = '',
  }) async {
    final response = await apiConsumer.get(
      EmployeePackagesApiEndPoints.packages(
        page: page,
        perPage: perPage,
        search: search,
      ),
      await _headers(languageCode),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == StatusCode.ok) {
      return EmployeePackagesResponseModel.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<EmployeePackageDetailsResponseModel> getPackageDetails({
    required String uuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      EmployeePackagesApiEndPoints.packageDetails(uuid),
      await _headers(languageCode),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == StatusCode.ok) {
      return EmployeePackageDetailsResponseModel.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<Map<String, String>> _headers(String languageCode) async {
    return {
      ConstantKeys.appAuthorization:
          '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
      ConstantKeys.acceptLanguage: languageCode,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }
}
