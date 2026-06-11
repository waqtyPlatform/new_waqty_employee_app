class ReportBugResponseModel {
  final bool success;
  final ReportBugModel? data;

  ReportBugResponseModel({required this.success, required this.data});

  factory ReportBugResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportBugResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? ReportBugModel.fromJson(json['data']) : null,
    );
  }
}

class ReportBugModel {
  final String uuid;
  final String category;
  final String description;
  final String? stepsToReproduce;
  final String? appVersion;
  final String status;
  final String? resolvedAt;
  final String createdAt;

  ReportBugModel({
    required this.uuid,
    required this.category,
    required this.description,
    this.stepsToReproduce,
    this.appVersion,
    required this.status,
    this.resolvedAt,
    required this.createdAt,
  });

  factory ReportBugModel.fromJson(Map<String, dynamic> json) {
    return ReportBugModel(
      uuid: json['uuid'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      stepsToReproduce: json['steps_to_reproduce'],
      appVersion: json['app_version'],
      status: json['status'] ?? '',
      resolvedAt: json['resolved_at'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
