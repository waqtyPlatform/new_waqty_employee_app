class BookingAddableItemsResponseModel {
  final bool success;
  final BookingAddableItemsDataModel data;

  const BookingAddableItemsResponseModel({
    required this.success,
    required this.data,
  });

  factory BookingAddableItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingAddableItemsResponseModel(
      success: json['success'] == true,
      data: BookingAddableItemsDataModel.fromJson(_asMap(json['data'])),
    );
  }
}

class BookingAddableItemsDataModel {
  final String bookingUuid;
  final String visitUuid;
  final String scheduledAt;
  final BookingAddableCustomerModel? customer;
  final List<BookingAddableServiceModel> services;
  final List<BookingAddablePackageModel> packagesAndOffers;
  final List<BookingAddableCustomerPackageModel> customerPackages;
  final List<BookingAddableFollowUpModel> followUps;

  const BookingAddableItemsDataModel({
    required this.bookingUuid,
    required this.visitUuid,
    required this.scheduledAt,
    required this.customer,
    required this.services,
    required this.packagesAndOffers,
    required this.customerPackages,
    required this.followUps,
  });

  factory BookingAddableItemsDataModel.fromJson(Map<String, dynamic> json) {
    return BookingAddableItemsDataModel(
      bookingUuid: _asString(json['booking_uuid']),
      visitUuid: _asString(json['visit_uuid']),
      scheduledAt: _asString(json['scheduled_at']),
      customer: _asMap(json['customer']).isEmpty
          ? null
          : BookingAddableCustomerModel.fromJson(_asMap(json['customer'])),
      services: _parseList(
        json['services'],
        BookingAddableServiceModel.fromJson,
      ),
      packagesAndOffers: _parseList(
        json['packages_and_offers'],
        BookingAddablePackageModel.fromJson,
      ),
      customerPackages: _parseList(
        json['customer_packages'],
        BookingAddableCustomerPackageModel.fromJson,
      ),
      followUps: _parseList(
        json['follow_ups'],
        BookingAddableFollowUpModel.fromJson,
      ),
    );
  }
}

class BookingAddableCustomerModel {
  final String uuid;
  final String name;

  const BookingAddableCustomerModel({required this.uuid, required this.name});

  factory BookingAddableCustomerModel.fromJson(Map<String, dynamic> json) {
    return BookingAddableCustomerModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
    );
  }
}

class BookingAddableServiceModel {
  final String uuid;
  final String itemType;
  final String sourceType;
  final String sourceUuid;
  final String name;
  final String category;
  final int durationMinutes;
  final String price;
  final String currency;

  const BookingAddableServiceModel({
    required this.uuid,
    required this.itemType,
    required this.sourceType,
    required this.sourceUuid,
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.price,
    required this.currency,
  });

  factory BookingAddableServiceModel.fromJson(Map<String, dynamic> json) {
    final uuid = _asString(json['uuid']);
    return BookingAddableServiceModel(
      uuid: uuid,
      itemType: _asString(json['item_type'], fallback: 'normal_service'),
      sourceType: _asString(json['source_type'], fallback: 'normal_service'),
      sourceUuid: _asString(json['source_uuid'], fallback: uuid),
      name: _asString(json['name']),
      category: _asString(json['category']),
      durationMinutes: _asInt(json['duration_minutes']),
      price: _asString(json['price'], fallback: '0'),
      currency: _asString(json['currency']),
    );
  }
}

class BookingAddablePackageModel {
  final String uuid;
  final String itemType;
  final String sourceType;
  final String sourceUuid;
  final String name;
  final String type;
  final String basePrice;
  final String effectivePrice;
  final bool hasActiveOffer;
  final BookingAddableOfferModel? offer;
  final int totalDurationMinutes;
  final int? sessionsIncluded;
  final int? initialUnits;
  final String? unitCode;
  final List<BookingAddablePackageServiceModel> services;

  const BookingAddablePackageModel({
    required this.uuid,
    required this.itemType,
    required this.sourceType,
    required this.sourceUuid,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.effectivePrice,
    required this.hasActiveOffer,
    required this.offer,
    required this.totalDurationMinutes,
    required this.sessionsIncluded,
    required this.initialUnits,
    required this.unitCode,
    required this.services,
  });

  factory BookingAddablePackageModel.fromJson(Map<String, dynamic> json) {
    final uuid = _asString(json['uuid']);
    final type = _asString(json['type']);
    return BookingAddablePackageModel(
      uuid: uuid,
      itemType: _asString(json['item_type'], fallback: _packageItemType(type)),
      sourceType: _asString(
        json['source_type'],
        fallback: _packageSourceType(type),
      ),
      sourceUuid: _asString(json['source_uuid'], fallback: uuid),
      name: _asString(json['name']),
      type: type,
      basePrice: _asString(json['base_price'], fallback: '0'),
      effectivePrice: _asString(json['effective_price'], fallback: '0'),
      hasActiveOffer: json['has_active_offer'] == true,
      offer: _asMap(json['offer']).isEmpty
          ? null
          : BookingAddableOfferModel.fromJson(_asMap(json['offer'])),
      totalDurationMinutes: _asInt(json['total_duration_minutes']),
      sessionsIncluded: _asNullableInt(json['sessions_included']),
      initialUnits: _asNullableInt(json['initial_units']),
      unitCode: _asNullableString(json['unit_code']),
      services: _parseList(
        json['services'],
        BookingAddablePackageServiceModel.fromJson,
      ),
    );
  }
}

class BookingAddableOfferModel {
  final String uuid;
  final String price;
  final String? endsAt;

  const BookingAddableOfferModel({
    required this.uuid,
    required this.price,
    required this.endsAt,
  });

  factory BookingAddableOfferModel.fromJson(Map<String, dynamic> json) {
    return BookingAddableOfferModel(
      uuid: _asString(json['uuid']),
      price: _asString(json['price'], fallback: '0'),
      endsAt: _asNullableString(json['ends_at']),
    );
  }
}

class BookingAddablePackageServiceModel {
  final String uuid;
  final String name;
  final int durationMinutes;
  final String price;

  const BookingAddablePackageServiceModel({
    required this.uuid,
    required this.name,
    required this.durationMinutes,
    required this.price,
  });

  factory BookingAddablePackageServiceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingAddablePackageServiceModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      durationMinutes: _asInt(json['duration_minutes']),
      price: _asString(json['price'], fallback: '0'),
    );
  }
}

class BookingAddableCustomerPackageModel {
  final String uuid;
  final String itemType;
  final String sourceType;
  final String sourceUuid;
  final String name;
  final String type;
  final String price;
  final String paidAmount;
  final String remainingAmount;
  final String paymentStatus;
  final BookingAddableBalanceModel? sessions;
  final BookingAddableBalanceModel? usage;
  final List<BookingAddablePackageServiceModel> services;

  const BookingAddableCustomerPackageModel({
    required this.uuid,
    required this.itemType,
    required this.sourceType,
    required this.sourceUuid,
    required this.name,
    required this.type,
    required this.price,
    required this.paidAmount,
    required this.remainingAmount,
    required this.paymentStatus,
    required this.sessions,
    required this.usage,
    required this.services,
  });

  factory BookingAddableCustomerPackageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final uuid = _asString(json['uuid']);
    final type = _asString(json['type']);
    return BookingAddableCustomerPackageModel(
      uuid: uuid,
      itemType: _asString(
        json['item_type'],
        fallback: _customerPackageItemType(type),
      ),
      sourceType: _asString(
        json['source_type'],
        fallback: _customerPackageSourceType(type),
      ),
      sourceUuid: _asString(json['source_uuid'], fallback: uuid),
      name: _asString(json['name']),
      type: type,
      price: _asString(json['price'], fallback: '0'),
      paidAmount: _asString(json['paid_amount'], fallback: '0'),
      remainingAmount: _asString(json['remaining_amount'], fallback: '0'),
      paymentStatus: _asString(json['payment_status']),
      sessions: _asMap(json['sessions']).isEmpty
          ? null
          : BookingAddableBalanceModel.fromJson(_asMap(json['sessions'])),
      usage: _asMap(json['usage']).isEmpty
          ? null
          : BookingAddableBalanceModel.fromJson(_asMap(json['usage'])),
      services: _parseList(
        json['services'],
        BookingAddablePackageServiceModel.fromJson,
      ),
    );
  }
}

class BookingAddableBalanceModel {
  final int available;
  final String? unitCode;
  final String? unitName;

  const BookingAddableBalanceModel({
    required this.available,
    required this.unitCode,
    required this.unitName,
  });

  factory BookingAddableBalanceModel.fromJson(Map<String, dynamic> json) {
    return BookingAddableBalanceModel(
      available: _asInt(json['available']),
      unitCode: _asNullableString(json['unit_code']),
      unitName: _asNullableString(json['unit_name']),
    );
  }
}

class BookingAddableFollowUpModel {
  final String uuid;
  final String itemType;
  final String sourceType;
  final String sourceUuid;
  final String status;
  final int availableCount;
  final String? validFrom;
  final String? validUntil;
  final String afterExpiryPolicy;
  final bool recommendedPeriodEnded;
  final String employeeRule;
  final String priceType;
  final String price;
  final BookingAddableFollowUpServiceModel service;
  final BookingAddableFollowUpSourceModel? source;

  const BookingAddableFollowUpModel({
    required this.uuid,
    required this.itemType,
    required this.sourceType,
    required this.sourceUuid,
    required this.status,
    required this.availableCount,
    required this.validFrom,
    required this.validUntil,
    required this.afterExpiryPolicy,
    required this.recommendedPeriodEnded,
    required this.employeeRule,
    required this.priceType,
    required this.price,
    required this.service,
    required this.source,
  });

  factory BookingAddableFollowUpModel.fromJson(Map<String, dynamic> json) {
    final uuid = _asString(json['uuid']);
    return BookingAddableFollowUpModel(
      uuid: uuid,
      itemType: _asString(json['item_type'], fallback: 'follow_up'),
      sourceType: _asString(json['source_type'], fallback: 'follow_up'),
      sourceUuid: _asString(json['source_uuid'], fallback: uuid),
      status: _asString(json['status']),
      availableCount: _asInt(json['available_count']),
      validFrom: _asNullableString(json['valid_from']),
      validUntil: _asNullableString(json['valid_until']),
      afterExpiryPolicy: _asString(json['after_expiry_policy']),
      recommendedPeriodEnded: json['recommended_period_ended'] == true,
      employeeRule: _asString(json['employee_rule']),
      priceType: _asString(json['price_type']),
      price: _asString(json['price'], fallback: '0'),
      service: BookingAddableFollowUpServiceModel.fromJson(
        _asMap(json['service']),
      ),
      source: _asMap(json['source']).isEmpty
          ? null
          : BookingAddableFollowUpSourceModel.fromJson(_asMap(json['source'])),
    );
  }
}

class BookingAddableFollowUpServiceModel {
  final String uuid;
  final String name;

  const BookingAddableFollowUpServiceModel({
    required this.uuid,
    required this.name,
  });

  factory BookingAddableFollowUpServiceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingAddableFollowUpServiceModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
    );
  }
}

class BookingAddableFollowUpSourceModel {
  final String bookingUuid;
  final String bookingItemUuid;

  const BookingAddableFollowUpSourceModel({
    required this.bookingUuid,
    required this.bookingItemUuid,
  });

  factory BookingAddableFollowUpSourceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingAddableFollowUpSourceModel(
      bookingUuid: _asString(json['booking_uuid']),
      bookingItemUuid: _asString(json['booking_item_uuid']),
    );
  }
}

List<T> _parseList<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) parser,
) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList() ??
      [];
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    return _asNullableString(value['ar'] ?? value['en']);
  }
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}

String _asString(dynamic value, {String fallback = ''}) {
  return _asNullableString(value) ?? fallback;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

int _asInt(dynamic value, {int fallback = 0}) {
  return _asNullableInt(value) ?? fallback;
}

String _packageSourceType(String type) {
  switch (type) {
    case 'multi_session':
    case 'usage_based':
      return type;
    case 'single_visit_package':
      return 'single_visit_package';
    default:
      return 'single_visit_package';
  }
}

String _customerPackageSourceType(String type) {
  switch (type) {
    case 'usage_based':
      return 'usage_based';
    default:
      return 'multi_session';
  }
}

String _packageItemType(String type) {
  switch (type) {
    case 'multi_session':
      return 'multi_session_package_purchase';
    case 'usage_based':
      return 'usage_package_purchase';
    default:
      return 'package_item';
  }
}

String _customerPackageItemType(String type) {
  switch (type) {
    case 'usage_based':
      return 'usage_package';
    default:
      return 'package_session';
  }
}
