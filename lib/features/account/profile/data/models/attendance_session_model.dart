class AttendanceSessionModel {
  final String uuid;
  final String status;
  final String? clockInAt;
  final String? clockOutAt;
  final String? breakStartedAt;
  final AttendanceBranchModel? branch;

  const AttendanceSessionModel({
    required this.uuid,
    required this.status,
    this.clockInAt,
    this.clockOutAt,
    this.breakStartedAt,
    this.branch,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    final latestBreakStartAt = _latestBreakStartAt(json['events']);

    return AttendanceSessionModel(
      uuid: json['uuid']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      clockInAt: json['clock_in_at']?.toString(),
      clockOutAt: json['clock_out_at']?.toString(),
      breakStartedAt:
          json['break_started_at']?.toString() ??
          json['break_start_at']?.toString() ??
          json['current_break_started_at']?.toString() ??
          json['break_start']?.toString() ??
          latestBreakStartAt,
      branch: _asMap(json['branch']).isEmpty
          ? null
          : AttendanceBranchModel.fromJson(_asMap(json['branch'])),
    );
  }

  bool get isOnBreak => status == 'on_break';

  static String? _latestBreakStartAt(dynamic events) {
    if (events is! List) return null;

    String? latestEventAt;
    for (final event in events) {
      if (event is! Map) continue;
      if (event['type']?.toString() != 'break_start') continue;

      final eventAt = event['event_at']?.toString();
      if (eventAt == null || eventAt.trim().isEmpty) continue;
      latestEventAt = eventAt;
    }

    return latestEventAt;
  }
}

class AttendanceBranchModel {
  final String uuid;
  final String name;
  final double? latitude;
  final double? longitude;
  final double? attendanceRangeMeters;

  const AttendanceBranchModel({
    required this.uuid,
    required this.name,
    this.latitude,
    this.longitude,
    this.attendanceRangeMeters,
  });

  factory AttendanceBranchModel.fromJson(Map<String, dynamic> json) {
    return AttendanceBranchModel(
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
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
