class ContactManagerResponseModel {
  final bool success;
  final ContactManagerMessageModel? data;

  ContactManagerResponseModel({required this.success, required this.data});

  factory ContactManagerResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactManagerResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ContactManagerMessageModel.fromJson(json['data'])
          : null,
    );
  }
}

class ContactManagerMessageModel {
  final String uuid;
  final String subject;
  final String message;
  final String priority;
  final String status;
  final String? resolvedAt;
  final String createdAt;

  ContactManagerMessageModel({
    required this.uuid,
    required this.subject,
    required this.message,
    required this.priority,
    required this.status,
    this.resolvedAt,
    required this.createdAt,
  });

  factory ContactManagerMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactManagerMessageModel(
      uuid: json['uuid'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      resolvedAt: json['resolved_at'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ContactManagerMessagesResponseModel {
  final bool success;
  final List<ContactManagerMessageModel> data;
  final ContactManagerPaginationModel pagination;

  const ContactManagerMessagesResponseModel({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory ContactManagerMessagesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ContactManagerMessagesResponseModel(
      success: json['success'] == true,
      data: _asList(
        json['data'],
      ).map((item) => ContactManagerMessageModel.fromJson(item)).toList(),
      pagination: ContactManagerPaginationModel.fromJson(
        _asMap(_asMap(json['meta'])['pagination'] ?? json['pagination']),
      ),
    );
  }
}

class ContactManagerPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const ContactManagerPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory ContactManagerPaginationModel.fromJson(Map<String, dynamic> json) {
    return ContactManagerPaginationModel(
      currentPage: _asInt(json['current_page'], 1),
      perPage: _asInt(json['per_page'], 15),
      total: _asInt(json['total'], 0),
      lastPage: _asInt(json['last_page'], 1),
    );
  }
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  return const [];
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}

int _asInt(dynamic value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
