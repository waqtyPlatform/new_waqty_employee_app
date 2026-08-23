class CustomerContextResponseModel {
  final bool success;
  final CustomerContextModel data;

  const CustomerContextResponseModel({
    required this.success,
    required this.data,
  });

  factory CustomerContextResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerContextResponseModel(
      success: json['success'] == true,
      data: CustomerContextModel.fromJson(_asMap(json['data'])),
    );
  }
}

class CustomerContextModel {
  final CustomerContextCustomerModel customer;
  final CustomerCapabilitiesModel capabilities;
  final List<CustomerPackagePurchaseModel> packages;
  final List<CustomerFollowUpModel> followUps;
  final List<AssignableCustomerPackageModel> assignablePackages;

  const CustomerContextModel({
    required this.customer,
    required this.capabilities,
    required this.packages,
    required this.followUps,
    required this.assignablePackages,
  });

  factory CustomerContextModel.fromJson(Map<String, dynamic> json) {
    return CustomerContextModel(
      customer: CustomerContextCustomerModel.fromJson(_asMap(json['customer'])),
      capabilities: CustomerCapabilitiesModel.fromJson(
        _asMap(json['capabilities']),
      ),
      packages: _parsePackagePurchases(json['packages']),
      followUps: _parseFollowUps(json['follow_ups'] ?? json['followUps']),
      assignablePackages: _parseAssignablePackages(
        json['assignable_packages'] ?? json['assignablePackages'],
      ),
    );
  }
}

class CustomerPackagesResponseModel {
  final bool success;
  final List<CustomerPackagePurchaseModel> data;

  const CustomerPackagesResponseModel({
    required this.success,
    required this.data,
  });

  factory CustomerPackagesResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerPackagesResponseModel(
      success: json['success'] == true,
      data: _parsePackagePurchases(json['data']),
    );
  }
}

class CustomerFollowUpsResponseModel {
  final bool success;
  final List<CustomerFollowUpModel> data;

  const CustomerFollowUpsResponseModel({
    required this.success,
    required this.data,
  });

  factory CustomerFollowUpsResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerFollowUpsResponseModel(
      success: json['success'] == true,
      data: _parseFollowUps(json['data']),
    );
  }
}

class CustomerContextCustomerModel {
  final String uuid;
  final String name;
  final String phone;
  final String? email;

  const CustomerContextCustomerModel({
    required this.uuid,
    required this.name,
    required this.phone,
    this.email,
  });

  factory CustomerContextCustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerContextCustomerModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      phone: _asString(json['phone']),
      email: _asNullableString(json['email']),
    );
  }
}

class CustomerCapabilitiesModel {
  final bool canViewCustomerPackages;
  final bool canAssignCustomerPackage;
  final bool canViewCustomerFollowUps;
  final bool canRecordUsage;

  const CustomerCapabilitiesModel({
    required this.canViewCustomerPackages,
    required this.canAssignCustomerPackage,
    required this.canViewCustomerFollowUps,
    required this.canRecordUsage,
  });

  factory CustomerCapabilitiesModel.fromJson(Map<String, dynamic> json) {
    return CustomerCapabilitiesModel(
      canViewCustomerPackages:
          json['can_view_customer_packages'] == true ||
          json['canViewCustomerPackages'] == true,
      canAssignCustomerPackage:
          json['can_assign_customer_package'] == true ||
          json['canAssignCustomerPackage'] == true,
      canViewCustomerFollowUps:
          json['can_view_customer_follow_ups'] == true ||
          json['canViewCustomerFollowUps'] == true,
      canRecordUsage:
          json['can_record_usage'] == true || json['canRecordUsage'] == true,
    );
  }
}

class CustomerPackagePurchaseModel {
  final String uuid;
  final String name;
  final String type;
  final String status;
  final String paymentStatus;
  final String purchasedAt;
  final String expiresAt;
  final String price;
  final String currency;
  final String paidAmount;
  final String remainingAmount;
  final CustomerPackageSessionsModel? sessions;
  final CustomerPackageUsageModel? usage;
  final List<CustomerPackageServiceModel> services;

  const CustomerPackagePurchaseModel({
    required this.uuid,
    required this.name,
    required this.type,
    required this.status,
    required this.paymentStatus,
    required this.purchasedAt,
    required this.expiresAt,
    required this.price,
    required this.currency,
    required this.paidAmount,
    required this.remainingAmount,
    this.sessions,
    this.usage,
    required this.services,
  });

  factory CustomerPackagePurchaseModel.fromJson(Map<String, dynamic> json) {
    final packageJson = _asMap(json['package']);
    final sessionsJson = _asMap(json['sessions']);
    final usageJson = _asMap(json['usage']);
    return CustomerPackagePurchaseModel(
      uuid: _asString(json['uuid'] ?? json['purchase_uuid']),
      name: _asString(json['name'] ?? packageJson['name']),
      type: _asString(json['type'] ?? packageJson['type']),
      status: _asString(json['status']),
      paymentStatus: _asString(json['payment_status'] ?? json['paymentStatus']),
      purchasedAt: _asString(json['purchased_at'] ?? json['purchasedAt']),
      expiresAt: _asString(json['expires_at'] ?? json['expiresAt']),
      price: _asString(json['price'] ?? packageJson['price'], fallback: '0'),
      currency: _asString(json['currency'] ?? packageJson['currency']),
      paidAmount: _asString(
        json['paid_amount'] ?? json['paidAmount'],
        fallback: '0',
      ),
      remainingAmount: _asString(
        json['remaining_amount'] ?? json['remainingAmount'],
        fallback: '0',
      ),
      sessions: sessionsJson.isEmpty
          ? null
          : CustomerPackageSessionsModel.fromJson(sessionsJson),
      usage: usageJson.isEmpty
          ? null
          : CustomerPackageUsageModel.fromJson(usageJson),
      services: _parsePackageServices(
        json['services'] ?? packageJson['services'],
      ),
    );
  }

  bool get isMultiSession => type == 'multi_session';
  bool get isUsageBased => type == 'usage_based';
}

class CustomerPackageSessionsModel {
  final int total;
  final int reserved;
  final int used;
  final int available;
  final int remaining;

  const CustomerPackageSessionsModel({
    required this.total,
    required this.reserved,
    required this.used,
    required this.available,
    required this.remaining,
  });

  factory CustomerPackageSessionsModel.fromJson(Map<String, dynamic> json) {
    return CustomerPackageSessionsModel(
      total: _asInt(json['total']),
      reserved: _asInt(json['reserved']),
      used: _asInt(json['used']),
      available: _asInt(json['available']),
      remaining: _asInt(json['remaining']),
    );
  }
}

class CustomerPackageUsageModel {
  final int? available;
  final int? totalPurchased;
  final int? totalConsumed;
  final bool? expired;
  final String? unitCode;
  final String? unitName;

  const CustomerPackageUsageModel({
    this.available,
    this.totalPurchased,
    this.totalConsumed,
    this.expired,
    this.unitCode,
    this.unitName,
  });

  factory CustomerPackageUsageModel.fromJson(Map<String, dynamic> json) {
    return CustomerPackageUsageModel(
      available: _asNullableInt(json['available'] ?? json['available_units']),
      totalPurchased: _asNullableInt(
        json['total_purchased'] ?? json['totalPurchased'],
      ),
      totalConsumed: _asNullableInt(
        json['total_consumed'] ?? json['totalConsumed'],
      ),
      expired: json['expired'] is bool ? json['expired'] as bool : null,
      unitCode: _asNullableString(json['unit_code'] ?? json['unitCode']),
      unitName: _asNullableString(json['unit_name'] ?? json['unitName']),
    );
  }
}

class CustomerPackageServiceModel {
  final String uuid;
  final String name;

  const CustomerPackageServiceModel({required this.uuid, required this.name});

  factory CustomerPackageServiceModel.fromJson(Map<String, dynamic> json) {
    return CustomerPackageServiceModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
    );
  }
}

class AssignableCustomerPackageModel {
  final String uuid;
  final String name;
  final String type;
  final String price;
  final String currency;
  final int? sessionsIncluded;
  final int? initialUnits;
  final String? unitCode;
  final String? unitName;

  const AssignableCustomerPackageModel({
    required this.uuid,
    required this.name,
    required this.type,
    required this.price,
    required this.currency,
    this.sessionsIncluded,
    this.initialUnits,
    this.unitCode,
    this.unitName,
  });

  factory AssignableCustomerPackageModel.fromJson(Map<String, dynamic> json) {
    return AssignableCustomerPackageModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      type: _asString(json['type']),
      price: _asString(json['price'], fallback: '0'),
      currency: _asString(json['currency']),
      sessionsIncluded: _asNullableInt(
        json['sessions_included'] ?? json['sessionsIncluded'],
      ),
      initialUnits: _asNullableInt(
        json['initial_units'] ?? json['initialUnits'],
      ),
      unitCode: _asNullableString(json['unit_code'] ?? json['unitCode']),
      unitName: _asNullableString(json['unit_name'] ?? json['unitName']),
    );
  }

  bool get canAssign => type == 'multi_session' || type == 'usage_based';
}

class CustomerFollowUpModel {
  final String uuid;
  final String serviceName;
  final String status;
  final int? availableCount;
  final String validUntil;
  final bool recommendedPeriodEnded;
  final String price;
  final String priceType;
  final String employeeRule;
  final String afterExpiryPolicy;

  const CustomerFollowUpModel({
    required this.uuid,
    required this.serviceName,
    required this.status,
    this.availableCount,
    required this.validUntil,
    required this.recommendedPeriodEnded,
    required this.price,
    required this.priceType,
    required this.employeeRule,
    required this.afterExpiryPolicy,
  });

  factory CustomerFollowUpModel.fromJson(Map<String, dynamic> json) {
    return CustomerFollowUpModel(
      uuid: _asString(json['uuid']),
      serviceName: _asString(
        json['service_name'] ?? json['serviceName'] ?? json['service'],
      ),
      status: _asString(json['status']),
      availableCount: _asNullableInt(
        json['available_count'] ?? json['availableCount'],
      ),
      validUntil: _asString(json['valid_until'] ?? json['validUntil']),
      recommendedPeriodEnded:
          json['recommended_period_ended'] == true ||
          json['recommendedPeriodEnded'] == true,
      price: _asString(json['price'], fallback: '0'),
      priceType: _asString(json['price_type'] ?? json['priceType']),
      employeeRule: _asString(json['employee_rule'] ?? json['employeeRule']),
      afterExpiryPolicy: _asString(
        json['after_expiry_policy'] ?? json['afterExpiryPolicy'],
      ),
    );
  }
}

List<CustomerPackagePurchaseModel> _parsePackagePurchases(dynamic value) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map(
            (item) => CustomerPackagePurchaseModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList() ??
      [];
}

List<AssignableCustomerPackageModel> _parseAssignablePackages(dynamic value) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map(
            (item) => AssignableCustomerPackageModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.canAssign)
          .toList() ??
      [];
}

List<CustomerFollowUpModel> _parseFollowUps(dynamic value) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map(
            (item) =>
                CustomerFollowUpModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList() ??
      [];
}

List<CustomerPackageServiceModel> _parsePackageServices(dynamic value) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map(
            (item) => CustomerPackageServiceModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList() ??
      [];
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

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
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
