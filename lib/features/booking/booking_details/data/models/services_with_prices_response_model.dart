class ServicesWithPricesResponseModel {
  final bool success;
  final List<ServiceWithPriceModel> data;
  final ServicesWithPricesMetaModel meta;

  ServicesWithPricesResponseModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory ServicesWithPricesResponseModel.fromJson(Map<String, dynamic> json) {
    return ServicesWithPricesResponseModel(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => ServiceWithPriceModel.fromJson(item))
              .toList() ??
          [],
      meta: ServicesWithPricesMetaModel.fromJson(json['meta'] ?? {}),
    );
  }
}

class ServiceWithPriceModel {
  final String uuid;
  final String subCategoryUuid;
  final String subCategoryName;
  final String category;
  final String name;
  final String description;
  final String? imageUrl;
  final int active;
  final int estimatedDurationMinutes;
  final ServicePricingModel pricing;

  ServiceWithPriceModel({
    required this.uuid,
    required this.subCategoryUuid,
    required this.subCategoryName,
    required this.category,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.active,
    required this.estimatedDurationMinutes,
    required this.pricing,
  });

  factory ServiceWithPriceModel.fromJson(Map<String, dynamic> json) {
    return ServiceWithPriceModel(
      uuid: json['uuid'] ?? '',
      subCategoryUuid: json['sub_category_uuid'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      active: json['active'] ?? 0,
      estimatedDurationMinutes: json['estimated_duration_minutes'] ?? 0,
      pricing: ServicePricingModel.fromJson(json['pricing'] ?? {}),
    );
  }
}

class ServicePricingModel {
  final String finalPrice;
  final String sourceType;
  final String? pricingGroup;

  ServicePricingModel({
    required this.finalPrice,
    required this.sourceType,
    this.pricingGroup,
  });

  factory ServicePricingModel.fromJson(Map<String, dynamic> json) {
    return ServicePricingModel(
      finalPrice: json['final_price']?.toString() ?? '0',
      sourceType: json['source_type'] ?? '',
      pricingGroup: json['pricing_group'],
    );
  }
}

class ServicesWithPricesMetaModel {
  final ServicesWithPricesPaginationModel pagination;

  ServicesWithPricesMetaModel({required this.pagination});

  factory ServicesWithPricesMetaModel.fromJson(Map<String, dynamic> json) {
    return ServicesWithPricesMetaModel(
      pagination: ServicesWithPricesPaginationModel.fromJson(
        json['pagination'] ?? {},
      ),
    );
  }
}

class ServicesWithPricesPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  ServicesWithPricesPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory ServicesWithPricesPaginationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServicesWithPricesPaginationModel(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}
