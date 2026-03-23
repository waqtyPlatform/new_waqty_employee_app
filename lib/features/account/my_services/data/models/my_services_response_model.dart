class MyServicesResponseModel {
  final bool success;
  final List<MyServiceModel> data;
  final MyServicesMetaModel? meta;

  MyServicesResponseModel({
    required this.success,
    required this.data,
    this.meta,
  });

  factory MyServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return MyServicesResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((i) => MyServiceModel.fromJson(i))
                .toList()
          : [],
      meta: json['meta'] != null
          ? MyServicesMetaModel.fromJson(json['meta'])
          : null,
    );
  }
}

class MyServiceModel {
  final String uuid;
  final String subCategoryUuid;
  final String subCategoryName;
  final String name;
  final String description;
  final String? imageUrl;
  final int active;
  final int? estimatedDurationMinutes;

  MyServiceModel({
    required this.uuid,
    required this.subCategoryUuid,
    required this.subCategoryName,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.active,
    this.estimatedDurationMinutes,
  });

  factory MyServiceModel.fromJson(Map<String, dynamic> json) {
    return MyServiceModel(
      uuid: json['uuid'] ?? '',
      subCategoryUuid: json['sub_category_uuid'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      active: json['active'] ?? 0,
      estimatedDurationMinutes: json['estimated_duration_minutes'],
    );
  }
}

class MyServicesMetaModel {
  final MyServicesPaginationModel pagination;

  MyServicesMetaModel({required this.pagination});

  factory MyServicesMetaModel.fromJson(Map<String, dynamic> json) {
    return MyServicesMetaModel(
      pagination: MyServicesPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class MyServicesPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  MyServicesPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory MyServicesPaginationModel.fromJson(Map<String, dynamic> json) {
    return MyServicesPaginationModel(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}
