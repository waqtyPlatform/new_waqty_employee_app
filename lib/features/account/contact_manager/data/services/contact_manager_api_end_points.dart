import 'package:new_waqty_employee_app/core/api/end_points.dart';

class ContactManagerApiEndPoints {
  static const String sendMessage =
      '${EndPoints.baseUrl}/api/employee/contact/messages';

  static String messages({required int page, required int perPage}) {
    return Uri.parse(sendMessage)
        .replace(
          queryParameters: {
            'page': page.toString(),
            'per_page': perPage.toString(),
          },
        )
        .toString();
  }
}
