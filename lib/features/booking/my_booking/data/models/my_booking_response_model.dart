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
      data:
          (json['data'] as List?)
              ?.map((item) => MyBookingModel.fromJson(item))
              .toList() ??
          [],
      meta: MyBookingMetaModel.fromJson(json['meta'] ?? {}),
    );
  }
}

class MyBookingModel {
  final String uuid;
  final String status;
  final String paymentStatus;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String price;
  final String currency;
  final String? notes;
  final MyBookingServiceModel service;
  final MyBookingBranchModel branch;
  final MyBookingUserModel? user;

  MyBookingModel({
    required this.uuid,
    required this.status,
    required this.paymentStatus,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.currency,
    this.notes,
    required this.service,
    required this.branch,
    this.user,
  });

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    return MyBookingModel(
      uuid: json['uuid'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      price: json['price']?.toString() ?? '',
      currency: json['currency'] ?? '',
      notes: json['notes'],
      service: MyBookingServiceModel.fromJson(json['service'] ?? {}),
      branch: MyBookingBranchModel.fromJson(json['branch'] ?? {}),
      user: json['user'] == null
          ? null
          : MyBookingUserModel.fromJson(json['user']),
    );
  }

  String get customerName => user?.name ?? '';

  String serviceNameForLanguage(String languageCode) {
    if (languageCode == 'ar') {
      return service.name.ar.isNotEmpty ? service.name.ar : service.name.en;
    }
    return service.name.en.isNotEmpty ? service.name.en : service.name.ar;
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
      uuid: json['uuid'] ?? '',
      id: json['id'],
      name: MyBookingLocalizedNameModel.fromJson(json['name'] ?? {}),
      estimatedDurationMinutes: json['estimated_duration_minutes'],
    );
  }
}

class MyBookingLocalizedNameModel {
  final String ar;
  final String en;

  MyBookingLocalizedNameModel({required this.ar, required this.en});

  factory MyBookingLocalizedNameModel.fromJson(Map<String, dynamic> json) {
    return MyBookingLocalizedNameModel(
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
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
      uuid: json['uuid'] ?? '',
      id: json['id'],
      name: json['name'] ?? '',
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
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class MyBookingMetaModel {
  final MyBookingPaginationModel pagination;

  MyBookingMetaModel({required this.pagination});

  factory MyBookingMetaModel.fromJson(Map<String, dynamic> json) {
    return MyBookingMetaModel(
      pagination: MyBookingPaginationModel.fromJson(json['pagination'] ?? {}),
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
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 30,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}
