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
