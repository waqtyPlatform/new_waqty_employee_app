class AttendanceSessionModel {
  final String uuid;
  final String status;
  final String? clockInAt;
  final String? clockOutAt;
  final String? breakStartedAt;
  final String? startTime;
  final String? endTime;
  final AttendanceBranchModel? branch;
  final PresenceConfirmationModel? presenceConfirmation;

  const AttendanceSessionModel({
    required this.uuid,
    required this.status,
    this.clockInAt,
    this.clockOutAt,
    this.breakStartedAt,
    this.startTime,
    this.endTime,
    this.branch,
    this.presenceConfirmation,
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
      startTime:
          _asString(json['start_time']) ??
          _asString(json['shift_start_time']) ??
          _asString(json['scheduled_start_at']) ??
          _asString(json['shift_start_at']) ??
          _asString(_asMap(json['shift'])['start_time']),
      endTime:
          _asString(json['end_time']) ??
          _asString(json['shift_end_time']) ??
          _asString(json['scheduled_end_at']) ??
          _asString(json['shift_end_at']) ??
          _asString(_asMap(json['shift'])['end_time']),
      branch: _asMap(json['branch']).isEmpty
          ? null
          : AttendanceBranchModel.fromJson(_asMap(json['branch'])),
      presenceConfirmation: _asMap(json['presence_confirmation']).isEmpty
          ? null
          : PresenceConfirmationModel.fromJson(
              _asMap(json['presence_confirmation']),
            ),
    );
  }

  bool get isOnBreak => status == 'on_break';

  bool get hasWaitingPresenceConfirmation {
    final confirmation = presenceConfirmation;
    if (confirmation == null || confirmation.status != 'waiting') return false;

    final deadlineAt = confirmation.deadlineDateTime;
    if (deadlineAt == null) return true;

    return DateTime.now().isBefore(deadlineAt.toLocal());
  }

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

class AttendanceCurrentModel {
  final AttendanceSessionModel? session;
  final AttendanceContextModel? context;

  const AttendanceCurrentModel({this.session, this.context});

  factory AttendanceCurrentModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final meta = _asMap(json['meta']);
    final attendanceContext = _asMap(meta['attendance_context']);

    return AttendanceCurrentModel(
      session: data.isEmpty ? null : AttendanceSessionModel.fromJson(data),
      context: attendanceContext.isEmpty
          ? null
          : AttendanceContextModel.fromJson(attendanceContext),
    );
  }
}

class AttendanceContextModel {
  final String? serverTime;
  final String? workDate;
  final String? timezone;
  final AttendanceBranchModel? branch;
  final List<AttendanceContextShiftModel> shifts;

  const AttendanceContextModel({
    this.serverTime,
    this.workDate,
    this.timezone,
    this.branch,
    this.shifts = const [],
  });

  factory AttendanceContextModel.fromJson(Map<String, dynamic> json) {
    return AttendanceContextModel(
      serverTime: _asString(json['server_time']),
      workDate: _asString(json['work_date']),
      timezone: _asString(json['timezone']),
      branch: _asMap(json['branch']).isEmpty
          ? null
          : AttendanceBranchModel.fromJson(_asMap(json['branch'])),
      shifts: (json['shifts'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (item) => AttendanceContextShiftModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}

class AttendanceContextShiftModel {
  final String? sourceType;
  final String? workDate;
  final String? startAt;
  final String? endAt;
  final int? allowedBreakMinutes;
  final int? requiredMinutes;
  final bool isLeave;
  final String? leaveType;
  final AttendanceBranchModel? branch;

  const AttendanceContextShiftModel({
    this.sourceType,
    this.workDate,
    this.startAt,
    this.endAt,
    this.allowedBreakMinutes,
    this.requiredMinutes,
    this.isLeave = false,
    this.leaveType,
    this.branch,
  });

  factory AttendanceContextShiftModel.fromJson(Map<String, dynamic> json) {
    return AttendanceContextShiftModel(
      sourceType: _asString(json['source_type']),
      workDate: _asString(json['work_date']),
      startAt: _asString(json['start_at']),
      endAt: _asString(json['end_at']),
      allowedBreakMinutes: _asInt(json['allowed_break_minutes']),
      requiredMinutes: _asInt(json['required_minutes']),
      isLeave: _asBool(json['is_leave']) ?? false,
      leaveType: _asString(json['leave_type']),
      branch: _asMap(json['branch']).isEmpty
          ? null
          : AttendanceBranchModel.fromJson(_asMap(json['branch'])),
    );
  }
}

class PresenceConfirmationModel {
  final String cycleId;
  final String status;
  final String? dueAt;
  final String? sentAt;
  final String? deadlineAt;
  final String? expectedEndAt;
  final String? response;
  final String? respondedAt;
  final bool? withinBranchRange;
  final double? distanceMeters;
  final String? closeReason;
  final String? closedAt;
  final bool? requiresReview;

  const PresenceConfirmationModel({
    required this.cycleId,
    required this.status,
    this.dueAt,
    this.sentAt,
    this.deadlineAt,
    this.expectedEndAt,
    this.response,
    this.respondedAt,
    this.withinBranchRange,
    this.distanceMeters,
    this.closeReason,
    this.closedAt,
    this.requiresReview,
  });

  factory PresenceConfirmationModel.fromJson(Map<String, dynamic> json) {
    return PresenceConfirmationModel(
      cycleId: json['cycle_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dueAt: json['due_at']?.toString(),
      sentAt: json['sent_at']?.toString(),
      deadlineAt: json['deadline_at']?.toString(),
      expectedEndAt: json['expected_end_at']?.toString(),
      response: json['response']?.toString(),
      respondedAt: json['responded_at']?.toString(),
      withinBranchRange: _asBool(json['within_branch_range']),
      distanceMeters: _asDouble(json['distance_meters']),
      closeReason: json['close_reason']?.toString(),
      closedAt: json['closed_at']?.toString(),
      requiresReview: _asBool(json['requires_review']),
    );
  }

  DateTime? get deadlineDateTime => _asDateTime(deadlineAt);

  DateTime? get expectedEndDateTime => _asDateTime(expectedEndAt);
}

class AttendanceBranchModel {
  final String uuid;
  final String name;
  final double? latitude;
  final double? longitude;
  final double? attendanceRangeMeters;
  final String? address;
  final String? openTime;
  final String? closeTime;
  final String? workingHours;

  const AttendanceBranchModel({
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

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

String? _asString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  final stringValue = value?.toString().toLowerCase();
  if (stringValue == 'true' || stringValue == '1') return true;
  if (stringValue == 'false' || stringValue == '0') return false;
  return null;
}

DateTime? _asDateTime(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return DateTime.tryParse(value.trim());
}
