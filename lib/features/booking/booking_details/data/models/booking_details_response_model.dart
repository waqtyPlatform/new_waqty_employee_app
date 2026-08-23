class BookingDetailsResponseModel {
  final bool success;
  final BookingDetailsModel data;

  BookingDetailsResponseModel({required this.success, required this.data});

  factory BookingDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsResponseModel(
      success: json['success'] ?? false,
      data: BookingDetailsModel.fromJson(_asMap(json['data'])),
    );
  }
}

class BookingDetailsModel {
  final String uuid;
  final String reference;
  final String status;
  final String employeeStatus;
  final String statusGroup;
  final String statusLabel;
  final String paymentStatus;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String scheduledStartAt;
  final String scheduledEndAt;
  final int plannedDurationMinutes;
  final String price;
  final String currency;
  final String? notes;
  final BookingDetailsServiceModel service;
  final BookingDetailsBranchModel branch;
  final BookingDetailsUserModel? user;
  final BookingDetailsCustomerModel? customer;
  final List<BookingServiceLine> services;
  final List<BookingVisitModel> visits;
  final List<BookingAssignedItemModel> assignedItems;
  final BookingTotalsModel totals;
  final BookingActionsModel actions;

  BookingDetailsModel({
    required this.uuid,
    required this.reference,
    required this.status,
    required this.employeeStatus,
    required this.statusGroup,
    required this.statusLabel,
    required this.paymentStatus,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
    required this.plannedDurationMinutes,
    required this.price,
    required this.currency,
    this.notes,
    required this.service,
    required this.branch,
    this.user,
    this.customer,
    required this.services,
    required this.visits,
    required this.assignedItems,
    required this.totals,
    required this.actions,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    final assignedItemsJson = json['assigned_items'] is List
        ? json['assigned_items'] as List
        : null;
    final firstItem = assignedItemsJson?.isNotEmpty == true
        ? _asMap(assignedItemsJson!.first)
        : null;
    final serviceJson = _asMap(json['service'] ?? firstItem?['service']);
    final customerJson = json['customer'] ?? json['user'];
    final totals = BookingTotalsModel.fromJson(_asMap(json['totals']));
    final fallbackStart =
        json['start_time'] ?? _timeOnly(json['scheduled_start_at']);
    final fallbackEnd = json['end_time'] ?? _timeOnly(json['scheduled_end_at']);

    final assignedItems =
        assignedItemsJson
            ?.whereType<Map>()
            .map(
              (item) => BookingAssignedItemModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList() ??
        <BookingAssignedItemModel>[];

    return BookingDetailsModel(
      uuid: _asString(json['uuid']),
      reference: _asString(json['reference']),
      status: _asString(json['status']),
      employeeStatus: _asString(json['employee_status']),
      statusGroup: _asString(json['status_group']),
      statusLabel: _asString(json['status_label']),
      paymentStatus: _asString(json['payment_status']),
      bookingDate: _asString(json['booking_date']),
      startTime: _asString(fallbackStart),
      endTime: _asString(fallbackEnd),
      scheduledStartAt: _asString(json['scheduled_start_at']),
      scheduledEndAt: _asString(json['scheduled_end_at']),
      plannedDurationMinutes: _asInt(json['planned_duration_minutes']),
      price: _asString(json['price'] ?? totals.price, fallback: '0'),
      currency: _asString(json['currency'] ?? totals.currency),
      notes: _asNullableString(json['notes']),
      service: BookingDetailsServiceModel.fromJson(serviceJson),
      branch: BookingDetailsBranchModel.fromJson(_asMap(json['branch'])),
      user: json['user'] == null
          ? null
          : BookingDetailsUserModel.fromJson(_asMap(json['user'])),
      customer: customerJson == null
          ? null
          : BookingDetailsCustomerModel.fromJson(_asMap(customerJson)),
      services: _parseServices(json['services']),
      visits:
          (json['visits'] is List ? json['visits'] as List : null)
              ?.whereType<Map>()
              .map((item) {
                final visitJson = Map<String, dynamic>.from(item);
                final visitUuid = _asString(visitJson['uuid']);
                return BookingVisitModel.fromJson(
                  visitJson,
                  assignedItems: assignedItems
                      .where((item) => item.visitUuid == visitUuid)
                      .toList(),
                );
              })
              .toList() ??
          [],
      assignedItems: assignedItems,
      totals: totals,
      actions: BookingActionsModel.fromJson(_asMap(json['actions'])),
    );
  }

  String get bookingNumber => reference.isNotEmpty ? reference : uuid;

  String get customerName => customer?.name ?? user?.name ?? '';

  String serviceNameForLanguage(String languageCode) {
    if (languageCode == 'ar') {
      return service.name.ar.isNotEmpty ? service.name.ar : service.name.en;
    }
    return service.name.en.isNotEmpty ? service.name.en : service.name.ar;
  }

  List<BookingServiceLine> serviceLinesForDetails(String languageCode) {
    if (assignedItems.isNotEmpty) {
      return assignedItems
          .map((item) => item.toServiceLine(languageCode))
          .toList();
    }
    if (services.isNotEmpty) return services;

    final legacyName = serviceNameForLanguage(languageCode);
    if (legacyName.isEmpty) return const [];

    return [
      BookingServiceLine(
        itemUuid: assignedItems.isNotEmpty ? assignedItems.first.uuid : uuid,
        serviceUuid: service.uuid.isEmpty ? null : service.uuid,
        name: legacyName,
        category: null,
        price: price,
        currency: currency,
        durationMinutes: durationMinutes,
        isAdded: false,
        status: status,
      ),
    ];
  }

  int get startHour => _timePart(startTime, 0);
  int get startMinute => _timePart(startTime, 1);
  int get endHour => _timePart(endTime, 0);
  int get endMinute => _timePart(endTime, 1);
  int get durationMinutes {
    if (plannedDurationMinutes > 0) return plannedDurationMinutes;
    final start = (startHour * 60) + startMinute;
    final end = (endHour * 60) + endMinute;
    return end > start ? end - start : 0;
  }

  String get formattedStartTime => _formatTime(startHour, startMinute);
  String get formattedEndTime => _formatTime(endHour, endMinute);

  static int _timePart(String value, int index) {
    final parts = value.split(':');
    if (parts.length <= index) return 0;
    return int.tryParse(parts[index]) ?? 0;
  }

  static String _formatTime(int hour, int minute) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  static String? _timeOnly(dynamic value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) return null;
    final date = DateTime.tryParse(text);
    if (date != null) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:00';
    }
    return text;
  }
}

class BookingVisitModel {
  final String? uuid;
  final int number;
  final String status;
  final BookingDetailsBranchModel? branch;
  final String scheduledStartAt;
  final String scheduledEndAt;
  final String actualStartedAt;
  final String actualEndedAt;
  final int plannedDurationMinutes;
  final int actualDurationMinutes;
  final double occupancyPercentage;
  final int? waitingTimeMinutes;
  final int? customerLatenessMinutes;
  final String? notes;
  final List<BookingServiceLine> services;
  final BookingVisitTotalsModel totals;
  final BookingVisitActionsModel actions;
  final BookingCustomerReviewModel? customerReview;

  const BookingVisitModel({
    required this.uuid,
    required this.number,
    required this.status,
    required this.branch,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
    required this.actualStartedAt,
    required this.actualEndedAt,
    required this.plannedDurationMinutes,
    required this.actualDurationMinutes,
    required this.occupancyPercentage,
    required this.waitingTimeMinutes,
    required this.customerLatenessMinutes,
    required this.notes,
    required this.services,
    required this.totals,
    required this.actions,
    this.customerReview,
  });

  factory BookingVisitModel.fromJson(
    Map<String, dynamic> json, {
    List<BookingAssignedItemModel> assignedItems = const [],
  }) {
    final branchJson = _asMap(json['branch']);
    return BookingVisitModel(
      uuid: _asNullableString(json['uuid']),
      number: _asInt(json['number'], fallback: 1),
      status: _asString(json['status']),
      branch: branchJson.isEmpty
          ? null
          : BookingDetailsBranchModel.fromJson(branchJson),
      scheduledStartAt: _asString(json['scheduled_start_at']),
      scheduledEndAt: _asString(json['scheduled_end_at']),
      actualStartedAt: _asString(json['actual_started_at']),
      actualEndedAt: _asString(json['actual_ended_at']),
      plannedDurationMinutes: _asInt(json['planned_duration_minutes']),
      actualDurationMinutes: _asInt(json['actual_duration_minutes']),
      occupancyPercentage: _asDouble(json['occupancy_percentage']),
      waitingTimeMinutes: _asNullableInt(json['waiting_time_minutes']),
      customerLatenessMinutes: _asNullableInt(
        json['customer_lateness_minutes'],
      ),
      notes: _asNullableString(json['notes']),
      services: assignedItems.isNotEmpty
          ? assignedItems.map((item) => item.toServiceLine('ar')).toList()
          : _parseServices(json['assigned_items']).isNotEmpty
          ? _parseServices(json['assigned_items'])
          : _parseServices(json['services']),
      totals: BookingVisitTotalsModel.fromJson(_asMap(json['totals'])),
      actions: BookingVisitActionsModel.fromJson(_asMap(json['actions'])),
      customerReview: json['customer_review'] == null
          ? null
          : BookingCustomerReviewModel.fromJson(
              _asMap(json['customer_review']),
            ),
    );
  }
}

class BookingVisitActionsModel {
  final bool canCheckIn;
  final bool canMarkNoShow;
  final bool canCancel;
  final bool canReviewCustomer;

  const BookingVisitActionsModel({
    required this.canCheckIn,
    required this.canMarkNoShow,
    required this.canCancel,
    required this.canReviewCustomer,
  });

  factory BookingVisitActionsModel.fromJson(Map<String, dynamic> json) {
    return BookingVisitActionsModel(
      canCheckIn: json['can_check_in'] == true,
      canMarkNoShow: json['can_mark_no_show'] == true,
      canCancel: json['can_cancel'] == true,
      canReviewCustomer: json['can_review_customer'] == true,
    );
  }
}

class BookingCustomerReviewModel {
  final String uuid;
  final String bookingUuid;
  final String visitUuid;
  final int rating;
  final String comment;
  final String createdAt;
  final String updatedAt;

  const BookingCustomerReviewModel({
    required this.uuid,
    required this.bookingUuid,
    required this.visitUuid,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingCustomerReviewModel.fromJson(Map<String, dynamic> json) {
    return BookingCustomerReviewModel(
      uuid: _asString(json['uuid']),
      bookingUuid: _asString(json['booking_uuid']),
      visitUuid: _asString(json['visit_uuid']),
      rating: _asInt(json['rating']),
      comment: _asString(json['comment']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
    );
  }
}

class BookingVisitTotalsModel {
  final int servicesCount;
  final String price;
  final String currency;

  const BookingVisitTotalsModel({
    required this.servicesCount,
    required this.price,
    required this.currency,
  });

  factory BookingVisitTotalsModel.fromJson(Map<String, dynamic> json) {
    return BookingVisitTotalsModel(
      servicesCount: _asInt(json['services_count']),
      price: _asString(json['price'], fallback: '0'),
      currency: _asString(json['currency']),
    );
  }
}

class BookingServiceLine {
  final String itemUuid;
  final String? serviceUuid;
  final String? name;
  final String? category;
  final String price;
  final String? currency;
  final int durationMinutes;
  final bool isAdded;
  final String status;
  final BookingDetailsEmployeeModel? employee;
  final String scheduledStartAt;
  final String scheduledEndAt;
  final String actualStartedAt;
  final String actualEndedAt;
  final int actualDurationMinutes;
  final double occupancyPercentage;
  final bool canStart;
  final bool canEnd;
  final String sourceType;
  final String sourceTypeRaw;
  final bool coveredByPackage;
  final bool coveredByUsagePackage;
  final int? usageUnitsConsumed;
  final bool usageRecordingRequired;
  final PackageMeta? package;
  final UsagePackageMeta? usagePackage;
  final FollowUpMeta? followUp;
  final String newCharge;

  const BookingServiceLine({
    required this.itemUuid,
    required this.serviceUuid,
    required this.name,
    required this.category,
    required this.price,
    required this.currency,
    required this.durationMinutes,
    required this.isAdded,
    required this.status,
    this.employee,
    this.scheduledStartAt = '',
    this.scheduledEndAt = '',
    this.actualStartedAt = '',
    this.actualEndedAt = '',
    this.actualDurationMinutes = 0,
    this.occupancyPercentage = 0,
    this.canStart = false,
    this.canEnd = false,
    this.sourceType = 'normal_service',
    this.sourceTypeRaw = '',
    this.coveredByPackage = false,
    this.coveredByUsagePackage = false,
    this.usageUnitsConsumed,
    this.usageRecordingRequired = false,
    this.package,
    this.usagePackage,
    this.followUp,
    this.newCharge = '0',
  });

  factory BookingServiceLine.fromJson(Map<String, dynamic> json) {
    final employeeJson = _asMap(json['employee']);
    final packageJson = _asMap(json['package']);
    final usagePackageJson = _asMap(
      json['usage_package'] ?? json['usagePackage'],
    );
    final followUpJson = _asMap(json['follow_up'] ?? json['followUp']);
    final sourceType = _bookingItemSourceType(
      json,
      packageJson: packageJson,
      usagePackageJson: usagePackageJson,
      followUpJson: followUpJson,
    );
    return BookingServiceLine(
      itemUuid: _asString(json['item_uuid'] ?? json['uuid']),
      serviceUuid: _asNullableString(json['uuid']),
      name: _asNullableString(json['name'] ?? _asMap(json['service'])['name']),
      category: _asNullableString(json['category']),
      price: _asString(json['price'], fallback: '0'),
      currency: _asNullableString(json['currency']),
      durationMinutes: _asInt(json['duration_minutes']),
      isAdded: json['is_added'] == true,
      status: _asString(json['status']),
      employee: employeeJson.isEmpty
          ? null
          : BookingDetailsEmployeeModel.fromJson(employeeJson),
      scheduledStartAt: _asString(
        json['scheduled_start_at'] ?? json['start_at'],
      ),
      scheduledEndAt: _asString(json['scheduled_end_at'] ?? json['end_at']),
      actualStartedAt: _asString(json['actual_started_at']),
      actualEndedAt: _asString(json['actual_ended_at']),
      actualDurationMinutes: _asInt(json['actual_duration_minutes']),
      occupancyPercentage: _asDouble(json['occupancy_percentage']),
      canStart: json['can_start'] == true,
      canEnd: json['can_end'] == true,
      sourceType: sourceType,
      sourceTypeRaw: _asString(
        json['source_type_raw'] ?? json['sourceTypeRaw'],
      ),
      coveredByPackage:
          (json['covered_by_package'] ?? json['coveredByPackage']) == true,
      coveredByUsagePackage:
          (json['covered_by_usage_package'] ?? json['coveredByUsagePackage']) ==
          true,
      usageUnitsConsumed: _asNullableInt(
        json['usage_units_consumed'] ?? json['usageUnitsConsumed'],
      ),
      usageRecordingRequired:
          (json['usage_recording_required'] ??
              json['usageRecordingRequired']) ==
          true,
      package: packageJson.isEmpty ? null : PackageMeta.fromJson(packageJson),
      usagePackage: usagePackageJson.isEmpty
          ? null
          : UsagePackageMeta.fromJson(usagePackageJson),
      followUp: followUpJson.isEmpty
          ? null
          : FollowUpMeta.fromJson(followUpJson),
      newCharge: _asString(json['new_charge'], fallback: '0'),
    );
  }

  bool get isSingleVisitPackage => sourceType == 'single_visit_package';
  bool get isMultiSession => sourceType == 'multi_session';
  bool get isUsageBased => sourceType == 'usage_based';
  bool get isFollowUp => sourceType == 'follow_up';
}

class PackageMeta {
  final String? uuid;
  final String? purchaseUuid;
  final String? instanceId;
  final String? instanceUuid;
  final String? name;
  final String? type;
  final int? itemPosition;
  final List<PackageServiceMeta> services;
  final int? sessionNumber;
  final PackageSessionsMeta? sessions;
  final PackageUsageMeta? usage;
  final String? entitlementStatus;
  final String? expiresAt;
  final String? basePrice;
  final String? offerPrice;
  final String? effectivePrice;

  const PackageMeta({
    this.uuid,
    this.purchaseUuid,
    this.instanceId,
    this.instanceUuid,
    this.name,
    this.type,
    this.itemPosition,
    this.services = const [],
    this.sessionNumber,
    this.sessions,
    this.usage,
    this.entitlementStatus,
    this.expiresAt,
    this.basePrice,
    this.offerPrice,
    this.effectivePrice,
  });

  factory PackageMeta.fromJson(Map<String, dynamic> json) {
    return PackageMeta(
      uuid: _asNullableString(json['uuid']),
      purchaseUuid: _asNullableString(
        json['purchase_uuid'] ?? json['purchaseUuid'],
      ),
      instanceId: _asNullableString(json['instance_id'] ?? json['instanceId']),
      instanceUuid: _asNullableString(
        json['instance_uuid'] ?? json['instanceUuid'],
      ),
      name: _asNullableString(json['name']),
      type: _asNullableString(json['type']),
      itemPosition: _asNullableInt(
        json['item_position'] ?? json['itemPosition'],
      ),
      services:
          (json['services'] is List ? json['services'] as List : null)
              ?.whereType<Map>()
              .map(
                (item) => PackageServiceMeta.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          const [],
      sessionNumber: _asNullableInt(
        json['session_number'] ?? json['sessionNumber'],
      ),
      sessions: _asMap(json['sessions']).isEmpty
          ? null
          : PackageSessionsMeta.fromJson(_asMap(json['sessions'])),
      usage: _asMap(json['usage']).isEmpty
          ? null
          : PackageUsageMeta.fromJson(_asMap(json['usage'])),
      entitlementStatus: _asNullableString(
        json['entitlement_status'] ?? json['entitlementStatus'],
      ),
      expiresAt: _asNullableString(json['expires_at'] ?? json['expiresAt']),
      basePrice: _asNullableString(json['base_price'] ?? json['basePrice']),
      offerPrice: _asNullableString(json['offer_price'] ?? json['offerPrice']),
      effectivePrice: _asNullableString(
        json['effective_price'] ?? json['effectivePrice'],
      ),
    );
  }
}

class PackageServiceMeta {
  final String? uuid;
  final String? name;
  final int durationMinutes;

  const PackageServiceMeta({
    this.uuid,
    this.name,
    required this.durationMinutes,
  });

  factory PackageServiceMeta.fromJson(Map<String, dynamic> json) {
    return PackageServiceMeta(
      uuid: _asNullableString(json['uuid']),
      name: _asNullableString(json['name']),
      durationMinutes: _asInt(
        json['duration_minutes'] ?? json['durationMinutes'],
      ),
    );
  }
}

class PackageSessionsMeta {
  final int total;
  final int reserved;
  final int used;
  final int completed;
  final int available;
  final int remaining;

  const PackageSessionsMeta({
    required this.total,
    required this.reserved,
    required this.used,
    required this.completed,
    required this.available,
    required this.remaining,
  });

  factory PackageSessionsMeta.fromJson(Map<String, dynamic> json) {
    return PackageSessionsMeta(
      total: _asInt(json['total']),
      reserved: _asInt(json['reserved']),
      used: _asInt(json['used']),
      completed: _asInt(json['completed']),
      available: _asInt(json['available']),
      remaining: _asInt(json['remaining']),
    );
  }
}

class PackageUsageMeta {
  final int? availableUnits;
  final String? unitCode;
  final String? unitName;

  const PackageUsageMeta({this.availableUnits, this.unitCode, this.unitName});

  factory PackageUsageMeta.fromJson(Map<String, dynamic> json) {
    return PackageUsageMeta(
      availableUnits: _asNullableInt(
        json['available_units'] ?? json['availableUnits'],
      ),
      unitCode: _asNullableString(json['unit_code'] ?? json['unitCode']),
      unitName: _asNullableString(json['unit_name'] ?? json['unitName']),
    );
  }
}

class UsagePackageMeta {
  final String? uuid;
  final String? name;
  final PackageServiceMeta? selectedService;
  final List<PackageServiceMeta> allowedServices;
  final int? availableUnits;
  final String? unitCode;
  final String? unitName;
  final String? entitlementStatus;
  final String? expiresAt;

  const UsagePackageMeta({
    this.uuid,
    this.name,
    this.selectedService,
    this.allowedServices = const [],
    this.availableUnits,
    this.unitCode,
    this.unitName,
    this.entitlementStatus,
    this.expiresAt,
  });

  factory UsagePackageMeta.fromJson(Map<String, dynamic> json) {
    return UsagePackageMeta(
      uuid: _asNullableString(json['uuid']),
      name: _asNullableString(json['name']),
      selectedService:
          _asMap(json['selected_service'] ?? json['selectedService']).isEmpty
          ? null
          : PackageServiceMeta.fromJson(
              _asMap(json['selected_service'] ?? json['selectedService']),
            ),
      allowedServices:
          (json['allowed_services'] is List
                  ? json['allowed_services'] as List
                  : json['allowedServices'] is List
                  ? json['allowedServices'] as List
                  : null)
              ?.whereType<Map>()
              .map(
                (item) => PackageServiceMeta.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          const [],
      availableUnits: _asNullableInt(
        json['available_units'] ?? json['availableUnits'],
      ),
      unitCode: _asNullableString(json['unit_code'] ?? json['unitCode']),
      unitName: _asNullableString(json['unit_name'] ?? json['unitName']),
      entitlementStatus: _asNullableString(
        json['entitlement_status'] ?? json['entitlementStatus'],
      ),
      expiresAt: _asNullableString(json['expires_at'] ?? json['expiresAt']),
    );
  }
}

class FollowUpMeta {
  final String? uuid;
  final String? status;
  final int? availableCount;
  final int? remainingUses;
  final int? durationMinutes;
  final String? price;
  final String? validUntil;
  final String? afterExpiryPolicy;
  final String? employeeRule;
  final String? sourceBookingUuid;
  final String? sourceBookingItemUuid;
  final String? originalService;
  final String? originalEmployee;

  const FollowUpMeta({
    this.uuid,
    this.status,
    this.availableCount,
    this.remainingUses,
    this.durationMinutes,
    this.price,
    this.validUntil,
    this.afterExpiryPolicy,
    this.employeeRule,
    this.sourceBookingUuid,
    this.sourceBookingItemUuid,
    this.originalService,
    this.originalEmployee,
  });

  factory FollowUpMeta.fromJson(Map<String, dynamic> json) {
    return FollowUpMeta(
      uuid: _asNullableString(json['uuid']),
      status: _asNullableString(json['status']),
      availableCount: _asNullableInt(
        json['available_count'] ?? json['availableCount'],
      ),
      remainingUses: _asNullableInt(
        json['remaining_uses'] ?? json['remainingUses'],
      ),
      durationMinutes: _asNullableInt(
        json['duration_minutes'] ?? json['durationMinutes'],
      ),
      price: _asNullableString(json['price']),
      validUntil: _asNullableString(json['valid_until'] ?? json['validUntil']),
      afterExpiryPolicy: _asNullableString(
        json['after_expiry_policy'] ?? json['afterExpiryPolicy'],
      ),
      employeeRule: _asNullableString(
        json['employee_rule'] ?? json['employeeRule'],
      ),
      sourceBookingUuid: _asNullableString(
        json['source_booking_uuid'] ?? json['sourceBookingUuid'],
      ),
      sourceBookingItemUuid: _asNullableString(
        json['source_booking_item_uuid'] ?? json['sourceBookingItemUuid'],
      ),
      originalService: _asNullableString(
        json['original_service'] ?? json['originalService'],
      ),
      originalEmployee: _asNullableString(
        json['original_employee'] ?? json['originalEmployee'],
      ),
    );
  }
}

class BookingDetailsEmployeeModel {
  final String uuid;
  final String name;

  const BookingDetailsEmployeeModel({required this.uuid, required this.name});

  factory BookingDetailsEmployeeModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsEmployeeModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
    );
  }
}

class BookingDetailsServiceModel {
  final String uuid;
  final int? id;
  final BookingDetailsLocalizedNameModel name;
  final int? estimatedDurationMinutes;

  BookingDetailsServiceModel({
    required this.uuid,
    this.id,
    required this.name,
    this.estimatedDurationMinutes,
  });

  factory BookingDetailsServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsServiceModel(
      uuid: _asString(json['uuid']),
      id: _asNullableInt(json['id']),
      name: BookingDetailsLocalizedNameModel.fromDynamic(json['name']),
      estimatedDurationMinutes: _asNullableInt(
        json['estimated_duration_minutes'],
      ),
    );
  }
}

class BookingDetailsLocalizedNameModel {
  final String ar;
  final String en;

  BookingDetailsLocalizedNameModel({required this.ar, required this.en});

  factory BookingDetailsLocalizedNameModel.fromDynamic(dynamic value) {
    if (value is Map) {
      return BookingDetailsLocalizedNameModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    final text = value?.toString() ?? '';
    return BookingDetailsLocalizedNameModel(ar: text, en: text);
  }

  factory BookingDetailsLocalizedNameModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsLocalizedNameModel(
      ar: _asString(json['ar']),
      en: _asString(json['en']),
    );
  }
}

class BookingDetailsBranchModel {
  final String uuid;
  final int? id;
  final String name;

  BookingDetailsBranchModel({required this.uuid, this.id, required this.name});

  factory BookingDetailsBranchModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsBranchModel(
      uuid: _asString(json['uuid']),
      id: _asNullableInt(json['id']),
      name: _asString(json['name']),
    );
  }
}

class BookingDetailsUserModel {
  final String uuid;
  final String name;
  final String phone;

  BookingDetailsUserModel({
    required this.uuid,
    required this.name,
    required this.phone,
  });

  factory BookingDetailsUserModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsUserModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      phone: _asString(json['phone']),
    );
  }
}

class BookingDetailsCustomerModel {
  final String uuid;
  final String name;
  final String initials;
  final String phone;
  final int visitsCount;

  BookingDetailsCustomerModel({
    required this.uuid,
    required this.name,
    required this.initials,
    required this.phone,
    required this.visitsCount,
  });

  factory BookingDetailsCustomerModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsCustomerModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      initials: _asString(json['initials']),
      phone: _asString(json['phone']),
      visitsCount: _asInt(json['visits_count']),
    );
  }
}

class BookingAssignedItemModel {
  final String uuid;
  final String visitUuid;
  final BookingDetailsServiceModel service;
  final String startAt;
  final String endAt;
  final int durationMinutes;
  final String price;
  final String currency;
  final bool isAdded;
  final String status;
  final bool canStart;
  final bool canEnd;
  final String sourceType;
  final String sourceTypeRaw;
  final bool coveredByPackage;
  final bool coveredByUsagePackage;
  final int? usageUnitsConsumed;
  final bool usageRecordingRequired;
  final PackageMeta? package;
  final UsagePackageMeta? usagePackage;
  final FollowUpMeta? followUp;
  final String newCharge;

  BookingAssignedItemModel({
    required this.uuid,
    required this.visitUuid,
    required this.service,
    required this.startAt,
    required this.endAt,
    required this.durationMinutes,
    required this.price,
    required this.currency,
    required this.isAdded,
    required this.status,
    required this.canStart,
    required this.canEnd,
    required this.sourceType,
    required this.sourceTypeRaw,
    required this.coveredByPackage,
    required this.coveredByUsagePackage,
    required this.usageUnitsConsumed,
    required this.usageRecordingRequired,
    this.package,
    this.usagePackage,
    this.followUp,
    required this.newCharge,
  });

  factory BookingAssignedItemModel.fromJson(Map<String, dynamic> json) {
    final packageJson = _asMap(json['package']);
    final usagePackageJson = _asMap(
      json['usage_package'] ?? json['usagePackage'],
    );
    final followUpJson = _asMap(json['follow_up'] ?? json['followUp']);
    final sourceType = _bookingItemSourceType(
      json,
      packageJson: packageJson,
      usagePackageJson: usagePackageJson,
      followUpJson: followUpJson,
    );
    return BookingAssignedItemModel(
      uuid: _asString(json['uuid']),
      visitUuid: _asString(json['visit_uuid'] ?? json['visitUuid']),
      service: BookingDetailsServiceModel.fromJson(_asMap(json['service'])),
      startAt: _asString(json['start_at']),
      endAt: _asString(json['end_at']),
      durationMinutes: _asInt(json['duration_minutes']),
      price: _asString(json['price'], fallback: '0'),
      currency: _asString(json['currency']),
      isAdded: json['is_added'] == true,
      status: _asString(json['status']),
      canStart: json['can_start'] == true,
      canEnd: json['can_end'] == true,
      sourceType: sourceType,
      sourceTypeRaw: _asString(
        json['source_type_raw'] ?? json['sourceTypeRaw'],
      ),
      coveredByPackage:
          (json['covered_by_package'] ?? json['coveredByPackage']) == true,
      coveredByUsagePackage:
          (json['covered_by_usage_package'] ?? json['coveredByUsagePackage']) ==
          true,
      usageUnitsConsumed: _asNullableInt(
        json['usage_units_consumed'] ?? json['usageUnitsConsumed'],
      ),
      usageRecordingRequired:
          (json['usage_recording_required'] ??
              json['usageRecordingRequired']) ==
          true,
      package: packageJson.isEmpty ? null : PackageMeta.fromJson(packageJson),
      usagePackage: usagePackageJson.isEmpty
          ? null
          : UsagePackageMeta.fromJson(usagePackageJson),
      followUp: followUpJson.isEmpty
          ? null
          : FollowUpMeta.fromJson(followUpJson),
      newCharge: _asString(json['new_charge'], fallback: '0'),
    );
  }

  BookingServiceLine toServiceLine(String languageCode) {
    final serviceName = languageCode == 'ar'
        ? (service.name.ar.isNotEmpty ? service.name.ar : service.name.en)
        : (service.name.en.isNotEmpty ? service.name.en : service.name.ar);
    return BookingServiceLine(
      itemUuid: uuid,
      serviceUuid: service.uuid.isEmpty ? null : service.uuid,
      name: serviceName,
      category: null,
      price: price,
      currency: currency,
      durationMinutes: durationMinutes,
      isAdded: isAdded,
      status: status,
      scheduledStartAt: startAt,
      scheduledEndAt: endAt,
      canStart: canStart,
      canEnd: canEnd,
      sourceType: sourceType,
      sourceTypeRaw: sourceTypeRaw,
      coveredByPackage: coveredByPackage,
      coveredByUsagePackage: coveredByUsagePackage,
      usageUnitsConsumed: usageUnitsConsumed,
      usageRecordingRequired: usageRecordingRequired,
      package: package,
      usagePackage: usagePackage,
      followUp: followUp,
      newCharge: newCharge,
    );
  }
}

class BookingTotalsModel {
  final int servicesCount;
  final String price;
  final String bookingTotalPrice;
  final String currency;

  BookingTotalsModel({
    required this.servicesCount,
    required this.price,
    required this.bookingTotalPrice,
    required this.currency,
  });

  factory BookingTotalsModel.fromJson(Map<String, dynamic> json) {
    return BookingTotalsModel(
      servicesCount: _asInt(json['services_count']),
      price: _asString(json['price'], fallback: '0'),
      bookingTotalPrice: _asString(json['booking_total_price'], fallback: '0'),
      currency: _asString(json['currency']),
    );
  }
}

class BookingActionsModel {
  final bool canStart;
  final bool canComplete;
  final bool requiresItemActions;
  final bool canMarkNoShow;
  final bool canCancel;
  final bool canAddService;
  final bool canReviewCustomer;

  BookingActionsModel({
    required this.canStart,
    required this.canComplete,
    required this.requiresItemActions,
    required this.canMarkNoShow,
    required this.canCancel,
    required this.canAddService,
    required this.canReviewCustomer,
  });

  factory BookingActionsModel.fromJson(Map<String, dynamic> json) {
    return BookingActionsModel(
      canStart: json['can_start'] == true,
      canComplete: json['can_complete'] == true,
      requiresItemActions: json['requires_item_actions'] == true,
      canMarkNoShow: json['can_mark_no_show'] == true,
      canCancel: json['can_cancel'] == true,
      canAddService: json['can_add_service'] == true,
      canReviewCustomer: json['can_review_customer'] == true,
    );
  }
}

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

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<BookingServiceLine> _parseServices(dynamic value) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map(
            (item) =>
                BookingServiceLine.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList() ??
      [];
}

String _bookingItemSourceType(
  Map<String, dynamic> json, {
  required Map<String, dynamic> packageJson,
  required Map<String, dynamic> usagePackageJson,
  required Map<String, dynamic> followUpJson,
}) {
  final explicit = _asNullableString(json['source_type'] ?? json['sourceType']);
  if (explicit != null) return explicit;

  if (followUpJson.isNotEmpty) return 'follow_up';
  if (usagePackageJson.isNotEmpty) return 'usage_based';
  if (packageJson.isNotEmpty) {
    final packageType = _asString(packageJson['type']).toLowerCase();
    if (packageType.contains('usage')) return 'usage_based';
    if (packageType.contains('multi') || packageType.contains('session')) {
      return 'multi_session';
    }
    if (packageJson['session_number'] != null ||
        packageJson['sessionNumber'] != null ||
        _asMap(packageJson['sessions']).isNotEmpty) {
      return 'multi_session';
    }
    if (_asMap(packageJson['usage']).isNotEmpty) return 'usage_based';
    return 'single_visit_package';
  }

  return 'normal_service';
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return _asNullableString(map['ar'] ?? map['en']);
  }
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}

String _asString(dynamic value, {String fallback = ''}) {
  return _asNullableString(value) ?? fallback;
}
