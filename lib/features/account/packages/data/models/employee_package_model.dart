class EmployeePackagesResponseModel {
  final bool success;
  final List<EmployeePackageModel> data;
  final EmployeePackagesPaginationModel pagination;

  EmployeePackagesResponseModel({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory EmployeePackagesResponseModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] is Map ? json['meta'] as Map : const {};
    return EmployeePackagesResponseModel(
      success: json['success'] == true,
      data: json['data'] is List
          ? (json['data'] as List)
                .whereType<Map>()
                .map((item) => EmployeePackageModel.fromJson(item))
                .toList()
          : [],
      pagination: EmployeePackagesPaginationModel.fromJson(
        meta['pagination'] is Map ? meta['pagination'] as Map : const {},
      ),
    );
  }
}

class EmployeePackageDetailsResponseModel {
  final bool success;
  final EmployeePackageModel? data;

  EmployeePackageDetailsResponseModel({required this.success, this.data});

  factory EmployeePackageDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    return EmployeePackageDetailsResponseModel(
      success: json['success'] == true,
      data: data is Map ? EmployeePackageModel.fromJson(data) : null,
    );
  }
}

class EmployeePackageModel {
  final String uuid;
  final String? name;
  final String? description;
  final EmployeePackageBranchModel branch;
  final String status;
  final String statusLabel;
  final bool isBookable;
  final String packageType;
  final String packageTypeLabel;
  final String? sessionMode;
  final String? sessionModeLabel;
  final String availabilityType;
  final String availabilityLabel;
  final String? startsAt;
  final String? endsAt;
  final String timezone;
  final String currency;
  final String originalTotal;
  final String totalDiscount;
  final String packagePrice;
  final String effectivePrice;
  final int totalDurationMinutes;
  final int sessionsIncluded;
  final int? validityDays;
  final String? unitCode;
  final String? unitName;
  final int? initialUnits;
  final EmployeePackageOfferModel? currentOffer;
  final List<EmployeePackageItemModel> items;

  EmployeePackageModel({
    required this.uuid,
    required this.name,
    required this.description,
    required this.branch,
    required this.status,
    required this.statusLabel,
    required this.isBookable,
    required this.packageType,
    required this.packageTypeLabel,
    required this.sessionMode,
    required this.sessionModeLabel,
    required this.availabilityType,
    required this.availabilityLabel,
    required this.startsAt,
    required this.endsAt,
    required this.timezone,
    required this.currency,
    required this.originalTotal,
    required this.totalDiscount,
    required this.packagePrice,
    required this.effectivePrice,
    required this.totalDurationMinutes,
    required this.sessionsIncluded,
    required this.validityDays,
    required this.unitCode,
    required this.unitName,
    required this.initialUnits,
    required this.currentOffer,
    required this.items,
  });

  factory EmployeePackageModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeePackageModel(
      uuid: _asString(json['uuid']),
      name: _nullableString(json['name']),
      description: _nullableString(json['description']),
      branch: EmployeePackageBranchModel.fromJson(
        json['branch'] is Map ? json['branch'] as Map : const {},
      ),
      status: _asString(json['status']),
      statusLabel: _asString(json['status_label']),
      isBookable: json['is_bookable'] == true,
      packageType: _asString(json['package_type']),
      packageTypeLabel: _asString(json['package_type_label']),
      sessionMode: _nullableString(json['session_mode']),
      sessionModeLabel: _nullableString(json['session_mode_label']),
      availabilityType: _asString(json['availability_type']),
      availabilityLabel: _asString(json['availability_label']),
      startsAt: _nullableString(json['starts_at']),
      endsAt: _nullableString(json['ends_at']),
      timezone: _asString(json['timezone']),
      currency: _asString(json['currency']),
      originalTotal: _asMoney(json['original_total']),
      totalDiscount: _asMoney(json['total_discount']),
      packagePrice: _asMoney(json['package_price']),
      effectivePrice: _asMoney(json['effective_price']),
      totalDurationMinutes: _asInt(json['total_duration_minutes']),
      sessionsIncluded: _asInt(json['sessions_included']),
      validityDays: _asNullableInt(json['validity_days']),
      unitCode: _nullableString(json['unit_code']),
      unitName: _nullableString(json['unit_name']),
      initialUnits: _asNullableInt(json['initial_units']),
      currentOffer: json['current_offer'] is Map
          ? EmployeePackageOfferModel.fromJson(json['current_offer'] as Map)
          : null,
      items: json['items'] is List
          ? (json['items'] as List)
                .whereType<Map>()
                .map((item) => EmployeePackageItemModel.fromJson(item))
                .toList()
          : [],
    );
  }

  bool get hasOffer => currentOffer != null;

  bool get hasSessionMode =>
      packageType == 'multi_session' && sessionModeLabel?.isNotEmpty == true;
}

class EmployeePackageBranchModel {
  final String uuid;
  final String name;

  EmployeePackageBranchModel({required this.uuid, required this.name});

  factory EmployeePackageBranchModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeePackageBranchModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
    );
  }
}

class EmployeePackageItemModel {
  final String? serviceUuid;
  final String? name;
  final String originalPrice;
  final String discountAmount;
  final String packageItemPrice;
  final int durationMinutes;
  final int position;

  EmployeePackageItemModel({
    required this.serviceUuid,
    required this.name,
    required this.originalPrice,
    required this.discountAmount,
    required this.packageItemPrice,
    required this.durationMinutes,
    required this.position,
  });

  factory EmployeePackageItemModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeePackageItemModel(
      serviceUuid: _nullableString(json['service_uuid']),
      name: _nullableString(json['name']),
      originalPrice: _asMoney(json['original_price']),
      discountAmount: _asMoney(json['discount_amount']),
      packageItemPrice: _asMoney(json['package_item_price']),
      durationMinutes: _asInt(json['duration_minutes']),
      position: _asInt(json['position']),
    );
  }
}

class EmployeePackageOfferModel {
  final String uuid;
  final String offerPrice;
  final String startsAt;
  final String endsAt;
  final String afterOfferAction;

  EmployeePackageOfferModel({
    required this.uuid,
    required this.offerPrice,
    required this.startsAt,
    required this.endsAt,
    required this.afterOfferAction,
  });

  factory EmployeePackageOfferModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeePackageOfferModel(
      uuid: _asString(json['uuid']),
      offerPrice: _asMoney(json['offer_price']),
      startsAt: _asString(json['starts_at']),
      endsAt: _asString(json['ends_at']),
      afterOfferAction: _asString(json['after_offer_action']),
    );
  }
}

class EmployeePackagesPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  EmployeePackagesPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory EmployeePackagesPaginationModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeePackagesPaginationModel(
      currentPage: _asInt(json['current_page'], fallback: 1),
      perPage: _asInt(json['per_page'], fallback: 15),
      total: _asInt(json['total']),
      lastPage: _asInt(json['last_page'], fallback: 1),
    );
  }
}

String _asString(dynamic value) => value?.toString() ?? '';

String? _nullableString(dynamic value) {
  final text = value?.toString();
  return text == null || text.isEmpty ? null : text;
}

String _asMoney(dynamic value) => value?.toString() ?? '0.00';

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
