import 'package:new_waqty_employee_app/core/api/end_points.dart';

class ReportBugApiEndPoints {
  static const String sendBugReport =
      '${EndPoints.baseUrl}/employee/bug-reports';

  static String reports({required int page, required int perPage}) {
    return Uri.parse(sendBugReport)
        .replace(
          queryParameters: {
            'page': page.toString(),
            'per_page': perPage.toString(),
          },
        )
        .toString();
  }
}
