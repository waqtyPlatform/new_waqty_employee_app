import 'package:new_waqty_employee_app/core/api/end_points.dart';

class EmployeePackagesApiEndPoints {
  static String packages({
    required int page,
    int perPage = 15,
    String search = '',
  }) {
    final query = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (search.trim().isNotEmpty) 'search': search.trim(),
    };
    return Uri.parse(
      '${EndPoints.baseUrl}/employee/packages',
    ).replace(queryParameters: query).toString();
  }

  static String packageDetails(String uuid) {
    return '${EndPoints.baseUrl}/employee/packages/$uuid';
  }
}
