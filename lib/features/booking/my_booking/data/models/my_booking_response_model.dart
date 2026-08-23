import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';

class MyBookingResponseModel {
  final bool success;
  final List<MyBookingModel> data;
  final MyBookingMetaModel meta;

  MyBookingResponseModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory MyBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return MyBookingResponseModel(
      success: json['success'] ?? false,
      data: _parseBookings(json['data']),
      meta: MyBookingMetaModel.fromJson(_asMap(json['meta'])),
    );
  }
}

class MyBookingModel {
  final String uuid;
  final String visitUuid;
  final int? dailyQueueNumber;
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
  final MyBookingServiceModel service;
  final List<MyBookingServiceLine> services;
  final List<MyBookingVisitModel> visits;
  final int visitsCount;
  final MyBookingBranchModel branch;
  final MyBookingUserModel? user;
  final bool canCancel;

  MyBookingModel({
    required this.uuid,
    required this.visitUuid,
    this.dailyQueueNumber,
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
    required this.services,
    required this.visits,
    required this.visitsCount,
    required this.branch,
    this.user,
    required this.canCancel,
  });

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    final bookingJson = _asMap(json['booking']);
    final isVisitRow = bookingJson.isNotEmpty;
    final assignedItems = json['assigned_items'] is List
        ? json['assigned_items'] as List
        : null;
    final firstItem = assignedItems?.isNotEmpty == true
        ? _asMap(assignedItems!.first)
        : null;
    final serviceJson = _asMap(json['service'] ?? firstItem?['service']);
    final totals = _asMap(json['totals']);
    final actions = _asMap(json['actions']);
    final rawVisits = json['visits'] is List ? json['visits'] as List : null;
    final visits =
        rawVisits
            ?.whereType<Map>()
            .map(
              (item) =>
                  MyBookingVisitModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList() ??
        [];
    final services = _parseServices(json['services']);
    final visitServices = visits.expand((visit) => visit.services).toList();
    final start =
        json['start_time'] ??
        _timeOnly(json['scheduled_start_at'] ?? json['scheduled_start']);
    final end =
        json['end_time'] ??
        _timeOnly(json['scheduled_end_at'] ?? json['scheduled_end']);
    final scheduledStartAt = _asString(json['scheduled_start_at']);
    final scheduledEndAt = _asString(json['scheduled_end_at']);
    final bookingDate =
        json['booking_date'] ?? _dateOnly(json['scheduled_start_at']);

    return MyBookingModel(
      uuid: _asString(isVisitRow ? bookingJson['uuid'] : json['uuid']),
      visitUuid: _asString(isVisitRow ? json['uuid'] : json['visit_uuid']),
      dailyQueueNumber: _asNullableInt(json['daily_queue_number']),
      reference: _asString(
        isVisitRow ? bookingJson['reference'] : json['reference'],
      ),
      status: _asString(json['status'] ?? bookingJson['status']),
      employeeStatus: _asString(json['employee_status']),
      statusGroup: _asString(json['status_group']),
      statusLabel: _asString(json['status_label']),
      paymentStatus: _asString(
        json['payment_status'] ?? bookingJson['payment_status'],
      ),
      bookingDate: _asString(bookingDate),
      startTime: _asString(start),
      endTime: _asString(end),
      scheduledStartAt: scheduledStartAt,
      scheduledEndAt: scheduledEndAt,
      plannedDurationMinutes: _asInt(json['planned_duration_minutes']),
      price: _asString(json['price'] ?? totals['price']),
      currency: _asString(json['currency'] ?? totals['currency']),
      notes: _asNullableString(json['notes'] ?? bookingJson['notes']),
      service: MyBookingServiceModel.fromJson(serviceJson),
      services: services.isNotEmpty ? services : visitServices,
      visits: visits,
      visitsCount: _asInt(
        totals['visits_count'] ?? bookingJson['visits_count'],
        fallback: visits.isNotEmpty ? visits.length : 1,
      ),
      branch: MyBookingBranchModel.fromJson(_asMap(json['branch'])),
      user: (json['user'] ?? json['customer']) == null
          ? null
          : MyBookingUserModel.fromJson(
              _asMap(json['user'] ?? json['customer']),
            ),
      canCancel: _asBool(actions['can_cancel']),
    );
  }

  String get customerName => user?.name ?? '';

  String get displayStatusKey {
    if (employeeStatus.isNotEmpty) return employeeStatus;
    if (statusGroup.isNotEmpty) return statusGroup;
    return status;
  }

  String serviceNameForLanguage(String languageCode) {
    if (languageCode == 'ar') {
      return service.name.ar.isNotEmpty ? service.name.ar : service.name.en;
    }
    return service.name.en.isNotEmpty ? service.name.en : service.name.ar;
  }

  String servicesNamesForLanguage(String languageCode) {
    final names = services
        .map((service) => service.name?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    if (names.isNotEmpty) return names.join('، ');

    return serviceNameForLanguage(languageCode);
  }

  String get branchName => branch.name;
  int get startHour => _timePart(startTime, 0);
  int get startMinute => _timePart(startTime, 1);
  int get endHour => _timePart(endTime, 0);
  int get endMinute => _timePart(endTime, 1);

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
    final date = AppDateFormat.parseBackendDateTime(text);
    if (date == null) return text;
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:00';
  }

  static String? _dateOnly(dynamic value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) return null;
    final date = AppDateFormat.parseBackendDateTime(text);
    if (date == null) return null;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class MyBookingVisitModel {
  final String uuid;
  final int number;
  final int? dailyQueueNumber;
  final String status;
  final String scheduledStartAt;
  final String scheduledEndAt;
  final int plannedDurationMinutes;
  final List<MyBookingServiceLine> services;

  const MyBookingVisitModel({
    required this.uuid,
    required this.number,
    this.dailyQueueNumber,
    required this.status,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
    required this.plannedDurationMinutes,
    required this.services,
  });

  factory MyBookingVisitModel.fromJson(Map<String, dynamic> json) {
    return MyBookingVisitModel(
      uuid: _asString(json['uuid']),
      number: _asInt(json['number'], fallback: 1),
      dailyQueueNumber: _asNullableInt(json['daily_queue_number']),
      status: _asString(json['status']),
      scheduledStartAt: _asString(json['scheduled_start_at']),
      scheduledEndAt: _asString(json['scheduled_end_at']),
      plannedDurationMinutes: _asInt(json['planned_duration_minutes']),
      services: _parseServices(json['services']),
    );
  }
}

class MyBookingServiceLine {
  final String itemUuid;
  final String? serviceUuid;
  final String? name;
  final String? category;
  final String price;
  final String? currency;
  final int durationMinutes;
  final bool isAdded;
  final String status;

  const MyBookingServiceLine({
    required this.itemUuid,
    required this.serviceUuid,
    required this.name,
    required this.category,
    required this.price,
    required this.currency,
    required this.durationMinutes,
    required this.isAdded,
    required this.status,
  });

  factory MyBookingServiceLine.fromJson(Map<String, dynamic> json) {
    return MyBookingServiceLine(
      itemUuid: _asString(json['item_uuid']),
      serviceUuid: _asNullableString(json['uuid']),
      name: _asNullableString(json['name']),
      category: _asNullableString(json['category']),
      price: _asString(json['price'], fallback: '0'),
      currency: _asNullableString(json['currency']),
      durationMinutes: _asInt(json['duration_minutes']),
      isAdded: _asBool(json['is_added']),
      status: _asString(json['status']),
    );
  }
}

class MyBookingServiceModel {
  final String uuid;
  final int? id;
  final MyBookingLocalizedNameModel name;
  final int? estimatedDurationMinutes;

  MyBookingServiceModel({
    required this.uuid,
    this.id,
    required this.name,
    this.estimatedDurationMinutes,
  });

  factory MyBookingServiceModel.fromJson(Map<String, dynamic> json) {
    return MyBookingServiceModel(
      uuid: _asString(json['uuid']),
      id: _asNullableInt(json['id']),
      name: MyBookingLocalizedNameModel.fromDynamic(json['name']),
      estimatedDurationMinutes: _asNullableInt(
        json['estimated_duration_minutes'],
      ),
    );
  }
}

class MyBookingLocalizedNameModel {
  final String ar;
  final String en;

  MyBookingLocalizedNameModel({required this.ar, required this.en});

  factory MyBookingLocalizedNameModel.fromDynamic(dynamic value) {
    if (value is Map) {
      return MyBookingLocalizedNameModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    final text = value?.toString() ?? '';
    return MyBookingLocalizedNameModel(ar: text, en: text);
  }

  factory MyBookingLocalizedNameModel.fromJson(Map<String, dynamic> json) {
    return MyBookingLocalizedNameModel(
      ar: _asString(json['ar']),
      en: _asString(json['en']),
    );
  }
}

class MyBookingBranchModel {
  final String uuid;
  final int? id;
  final String name;

  MyBookingBranchModel({required this.uuid, this.id, required this.name});

  factory MyBookingBranchModel.fromJson(Map<String, dynamic> json) {
    return MyBookingBranchModel(
      uuid: _asString(json['uuid']),
      id: _asNullableInt(json['id']),
      name: _asString(json['name']),
    );
  }
}

class MyBookingUserModel {
  final String uuid;
  final String name;
  final String phone;

  MyBookingUserModel({
    required this.uuid,
    required this.name,
    required this.phone,
  });

  factory MyBookingUserModel.fromJson(Map<String, dynamic> json) {
    return MyBookingUserModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      phone: _asString(json['phone']),
    );
  }
}

class MyBookingMetaModel {
  final MyBookingPaginationModel pagination;

  MyBookingMetaModel({required this.pagination});

  factory MyBookingMetaModel.fromJson(Map<String, dynamic> json) {
    return MyBookingMetaModel(
      pagination: MyBookingPaginationModel.fromJson(_asMap(json['pagination'])),
    );
  }
}

class MyBookingPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  MyBookingPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory MyBookingPaginationModel.fromJson(Map<String, dynamic> json) {
    return MyBookingPaginationModel(
      currentPage: _asInt(json['current_page'], fallback: 1),
      perPage: _asInt(json['per_page'], fallback: 30),
      total: _asInt(json['total']),
      lastPage: _asInt(json['last_page'], fallback: 1),
    );
  }
}

List<MyBookingModel> _parseBookings(dynamic value) {
  if (value is! List) return [];
  final bookings = <MyBookingModel>[];
  for (final item in value) {
    final itemJson = _asMap(item);
    if (itemJson.isEmpty) continue;
    bookings.add(MyBookingModel.fromJson(itemJson));
  }
  return bookings;
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

List<MyBookingServiceLine> _parseServices(dynamic value) {
  return (value is List ? value : null)
          ?.whereType<Map>()
          .map(
            (item) =>
                MyBookingServiceLine.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList() ??
      [];
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

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  return text == 'true' || text == '1' || text == 'yes';
}
