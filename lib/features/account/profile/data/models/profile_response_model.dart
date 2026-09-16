class ProfileResponseModel {
  final ProfileCustomer customer;

  ProfileResponseModel({required this.customer});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      customer: ProfileCustomer.fromJson(_asMap(json['data'])),
    );
  }
}

class ProfileCustomer {
  final String uuid;
  final String name;
  final String phone;
  final String email;
  final String jobTitle;
  final String employeeCode;
  final String avatarUrl;
  final bool active;
  final bool blocked;
  final BranchModel branchModel;

  ProfileCustomer({
    required this.uuid,
    required this.name,
    required this.phone,
    required this.email,
    required this.jobTitle,
    required this.employeeCode,
    required this.avatarUrl,
    required this.active,
    required this.blocked,
    required this.branchModel,
  });

  factory ProfileCustomer.fromJson(Map<String, dynamic> json) {
    return ProfileCustomer(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      jobTitle: _asString(json['job_title']) ?? '',
      employeeCode:
          _asString(json['employee_code']) ??
          _asString(json['code']) ??
          _asString(json['employee_number']) ??
          _asString(json['employee_id']) ??
          '',
      avatarUrl:
          _asString(json['avatar_url']) ??
          _asString(json['profile_photo_url']) ??
          _asString(json['logo_url']) ??
          _asString(json['photo_url']) ??
          _asString(json['image_url']) ??
          _asString(json['avatar']) ??
          _asString(json['photo']) ??
          _asString(json['image']) ??
          '',
      active: json['active'] ?? true,
      blocked: json['blocked'] ?? false,
      branchModel: BranchModel.fromJson(_asMap(json['branch'])),
    );
  }
}

class BranchModel {
  final String uuid;
  final String name;
  final double? latitude;
  final double? longitude;
  final double? attendanceRangeMeters;
  final String? address;
  final String? openTime;
  final String? closeTime;
  final String? workingHours;

  BranchModel({
    required this.uuid,
    required this.name,
    this.latitude,
    this.longitude,
    this.attendanceRangeMeters,
    this.address,
    this.openTime,
    this.closeTime,
    this.workingHours,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      attendanceRangeMeters:
          _asDouble(json['attendance_range_meters']) ??
          _asDouble(json['attendance_radius_meters']) ??
          _asDouble(json['allowed_attendance_range_meters']) ??
          _asDouble(json['allowed_branch_range_meters']) ??
          _asDouble(json['branch_range_meters']) ??
          _asDouble(json['geofence_radius_meters']),
      address:
          _asString(json['address']) ??
          _asString(json['full_address']) ??
          _asString(json['location_address']),
      openTime:
          _asString(json['open_time']) ??
          _asString(json['opening_time']) ??
          _asString(json['starts_at']),
      closeTime:
          _asString(json['close_time']) ??
          _asString(json['closing_time']) ??
          _asString(json['ends_at']),
      workingHours:
          _asString(json['working_hours']) ??
          _asString(json['working_hours_text']) ??
          _asString(json['hours']),
    );
  }
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _asString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
