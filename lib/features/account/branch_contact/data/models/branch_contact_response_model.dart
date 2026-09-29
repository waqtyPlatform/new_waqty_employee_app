class BranchContactResponseModel {
  final bool success;
  final BranchContactModel? data;

  BranchContactResponseModel({required this.success, required this.data});

  factory BranchContactResponseModel.fromJson(Map<String, dynamic> json) {
    return BranchContactResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? BranchContactModel.fromJson(json['data'])
          : null,
    );
  }
}

class BranchContactModel {
  final String uuid;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final List<String> workingDays;
  final String? openTime;
  final String? closeTime;
  final String? hoursDisplay;

  BranchContactModel({
    required this.uuid,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.workingDays = const [],
    this.openTime,
    this.closeTime,
    this.hoursDisplay,
  });

  factory BranchContactModel.fromJson(Map<String, dynamic> json) {
    return BranchContactModel(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      mapUrl: json['map_url'],
      workingDays:
          (json['working_days'] as List?)
              ?.map(_normalizeDayCode)
              .where((day) => day.isNotEmpty)
              .toSet()
              .toList() ??
          [],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      hoursDisplay: json['hours_display'],
    );
  }
}

String _normalizeDayCode(dynamic value) {
  final day = value.toString().trim().toLowerCase();
  return switch (day) {
    '0' || '7' || 'sun' || 'sunday' || 'الأحد' || 'احد' => 'sun',
    '1' || 'mon' || 'monday' || 'الإثنين' || 'الاثنين' => 'mon',
    '2' || 'tue' || 'tuesday' || 'الثلاثاء' => 'tue',
    '3' || 'wed' || 'wednesday' || 'الأربعاء' || 'الاربعاء' => 'wed',
    '4' || 'thu' || 'thursday' || 'الخميس' => 'thu',
    '5' || 'fri' || 'friday' || 'الجمعة' => 'fri',
    '6' || 'sat' || 'saturday' || 'السبت' => 'sat',
    _ => day.length >= 3 ? day.substring(0, 3) : day,
  };
}
