class BookingDetailsResponseModel {
  final bool success;
  final BookingDetailsModel data;

  BookingDetailsResponseModel({required this.success, required this.data});

  factory BookingDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsResponseModel(
      success: json['success'] ?? false,
      data: BookingDetailsModel.fromJson(json['data'] ?? {}),
    );
  }
}

class BookingDetailsModel {
  final String uuid;
  final String status;
  final String paymentStatus;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String price;
  final String currency;
  final String? notes;
  final BookingDetailsServiceModel service;
  final BookingDetailsBranchModel branch;
  final BookingDetailsUserModel? user;

  BookingDetailsModel({
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

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      uuid: json['uuid'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      price: json['price']?.toString() ?? '0',
      currency: json['currency'] ?? '',
      notes: json['notes'],
      service: BookingDetailsServiceModel.fromJson(json['service'] ?? {}),
      branch: BookingDetailsBranchModel.fromJson(json['branch'] ?? {}),
      user: json['user'] == null
          ? null
          : BookingDetailsUserModel.fromJson(json['user']),
    );
  }

  String get bookingNumber => uuid;

  String get customerName => user?.name ?? '';

  String serviceNameForLanguage(String languageCode) {
    if (languageCode == 'ar') {
      return service.name.ar.isNotEmpty ? service.name.ar : service.name.en;
    }
    return service.name.en.isNotEmpty ? service.name.en : service.name.ar;
  }

  int get startHour => _timePart(startTime, 0);
  int get startMinute => _timePart(startTime, 1);
  int get endHour => _timePart(endTime, 0);
  int get endMinute => _timePart(endTime, 1);
  int get durationMinutes {
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
      uuid: json['uuid'] ?? '',
      id: json['id'],
      name: BookingDetailsLocalizedNameModel.fromJson(json['name'] ?? {}),
      estimatedDurationMinutes: json['estimated_duration_minutes'],
    );
  }
}

class BookingDetailsLocalizedNameModel {
  final String ar;
  final String en;

  BookingDetailsLocalizedNameModel({required this.ar, required this.en});

  factory BookingDetailsLocalizedNameModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsLocalizedNameModel(
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
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
      uuid: json['uuid'] ?? '',
      id: json['id'],
      name: json['name'] ?? '',
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
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
