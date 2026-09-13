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
  final String? resolutionNote;
  final String? escalatedAt;
  final String? resolvedAt;
  final String createdAt;

  ReportBugModel({
    required this.uuid,
    required this.category,
    required this.description,
    this.stepsToReproduce,
    this.appVersion,
    required this.status,
    this.resolutionNote,
    this.escalatedAt,
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
      resolutionNote: json['resolution_note'],
      escalatedAt: json['escalated_at'],
      resolvedAt: json['resolved_at'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ReportBugListResponseModel {
  final bool success;
  final List<ReportBugModel> data;
  final ReportBugPaginationModel pagination;

  const ReportBugListResponseModel({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory ReportBugListResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportBugListResponseModel(
      success: json['success'] == true,
      data: _asList(json['data']).map(ReportBugModel.fromJson).toList(),
      pagination: ReportBugPaginationModel.fromJson(
        _asMap(_asMap(json['meta'])['pagination'] ?? json['pagination']),
      ),
    );
  }
}

class ReportBugPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const ReportBugPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory ReportBugPaginationModel.fromJson(Map<String, dynamic> json) {
    return ReportBugPaginationModel(
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
