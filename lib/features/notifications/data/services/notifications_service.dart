import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notifications_response_model.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_api_end_points.dart';

class NotificationsService {
  final ApiConsumer apiConsumer;

  NotificationsService({required this.apiConsumer});

  Future<NotificationsResponseModel> getNotifications({
    required String languageCode,
    required String status,
    required int page,
    int perPage = 20,
    String? type,
    String? category,
  }) async {
    final response = await apiConsumer.get(
      NotificationApiEndPoints.notifications(
        status: status,
        page: page,
        perPage: perPage,
        type: type,
        category: category,
      ),
      await _headers(languageCode),
    );
    final body = _decode(response.body);
    if (response.statusCode == StatusCode.ok) {
      return NotificationsResponseModel.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<NotificationUnreadCountModel> getUnreadCount({
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      NotificationApiEndPoints.unreadCount,
      await _headers(languageCode),
    );
    final body = _decode(response.body);
    if (response.statusCode == StatusCode.ok) {
      return NotificationUnreadCountModel.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<NotificationInboxItemModel?> markRead({
    required String uuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.patch(
      NotificationApiEndPoints.markRead(uuid),
      const {},
      await _headers(languageCode),
    );
    final body = _decode(response.body);
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final notification = _extractNotification(body);
      return notification == null
          ? null
          : NotificationInboxItemModel.fromJson(notification);
    } else {
      throw ServerException(serverFailure: ServerFailure.fromJson(body));
    }
  }

  Future<void> markAllRead({required String languageCode}) async {
    final response = await apiConsumer.patch(
      NotificationApiEndPoints.readAll,
      const {},
      await _headers(languageCode),
    );
    if (response.statusCode != StatusCode.ok &&
        response.statusCode != StatusCode.created) {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(_decode(response.body)),
      );
    }
  }

  Future<Map<String, String>> _headers(String languageCode) async {
    return {
      ConstantKeys.appAuthorization:
          '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
      ConstantKeys.acceptLanguage: languageCode,
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return <String, dynamic>{};
  }

  Map<String, dynamic>? _extractNotification(Map<String, dynamic> body) {
    final data = body['data'];
    final candidates = [
      body['notification'],
      data is Map ? data['notification'] : null,
      data,
    ];
    for (final candidate in candidates) {
      if (candidate is Map) return Map<String, dynamic>.from(candidate);
    }
    return null;
  }
}
