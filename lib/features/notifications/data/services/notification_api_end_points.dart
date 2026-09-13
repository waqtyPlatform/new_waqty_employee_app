import 'package:new_waqty_employee_app/core/api/end_points.dart';

class NotificationApiEndPoints {
  static const String unreadCount =
      '${EndPoints.baseUrl}/api/employee/notifications/unread-count';
  static const String readAll =
      '${EndPoints.baseUrl}/api/employee/notifications/read-all';

  static String notifications({
    required String status,
    required int page,
    required int perPage,
    String? type,
    String? category,
  }) {
    final params = <String, String>{
      'status': status,
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (type != null && type.isNotEmpty) 'type': type,
      if (category != null && category.isNotEmpty) 'category': category,
    };
    return Uri.parse(
      '${EndPoints.baseUrl}/api/employee/notifications',
    ).replace(queryParameters: params).toString();
  }

  static String markRead(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/notifications/$uuid/read';
  }
}
