import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';

class NotificationsResponseModel {
  final bool success;
  final List<NotificationInboxItemModel> data;
  final NotificationsPaginationModel pagination;

  const NotificationsResponseModel({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataNode = json['data'];
    final list = _extractList(dataNode);
    return NotificationsResponseModel(
      success: json['success'] == true,
      data: list.whereType<Map>().map((item) {
        return NotificationInboxItemModel.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList(),
      pagination: NotificationsPaginationModel.fromJson(
        _extractPagination(json, dataNode),
      ),
    );
  }

  static List<dynamic> _extractList(dynamic dataNode) {
    if (dataNode is List) return dataNode;
    if (dataNode is Map) {
      final candidates = [
        dataNode['notifications'],
        dataNode['items'],
        dataNode['data'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return const [];
  }

  static Map<String, dynamic> _extractPagination(
    Map<String, dynamic> json,
    dynamic dataNode,
  ) {
    final candidates = [
      json['pagination'],
      json['meta'] is Map ? (json['meta'] as Map)['pagination'] : null,
      json['meta'],
      dataNode is Map ? dataNode['pagination'] : null,
    ];
    for (final candidate in candidates) {
      if (candidate is Map) return Map<String, dynamic>.from(candidate);
    }
    return const {};
  }
}

class NotificationsPaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const NotificationsPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory NotificationsPaginationModel.fromJson(Map<String, dynamic> json) {
    return NotificationsPaginationModel(
      currentPage: _asInt(json['current_page'] ?? json['currentPage'], 1),
      lastPage: _asInt(json['last_page'] ?? json['lastPage'], 1),
      perPage: _asInt(json['per_page'] ?? json['perPage'], 20),
      total: _asInt(json['total'], 0),
    );
  }
}

class NotificationUnreadCountModel {
  final int count;

  const NotificationUnreadCountModel({required this.count});

  factory NotificationUnreadCountModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return NotificationUnreadCountModel(
        count: _asInt(
          data['unread_count'] ?? data['count'] ?? data['total_unread'],
          0,
        ),
      );
    }
    return NotificationUnreadCountModel(
      count: _asInt(json['unread_count'] ?? json['count'], 0),
    );
  }
}

int _asInt(dynamic value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
