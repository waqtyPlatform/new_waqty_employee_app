enum AttendanceStatus { present, late, absent, earlyLeave, dayOff, today }

class AttendanceResponseModel {
  final bool success;
  final AttendanceDataModel data;

  const AttendanceResponseModel({required this.success, required this.data});

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      success: json['success'] == true,
      data: AttendanceDataModel.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }
}

class AttendanceDataModel {
  final AttendanceMonthModel month;
  final AttendanceSummaryModel summary;
  final List<AttendanceDayModel> days;

  const AttendanceDataModel({
    required this.month,
    required this.summary,
    required this.days,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    final attendanceMap = _attendanceByDate(json['attendance']);
    final calendar = json['calendar'] is List ? json['calendar'] as List : [];

    return AttendanceDataModel(
      month: AttendanceMonthModel.fromJson(
        json['month'] is Map<String, dynamic>
            ? json['month'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
      summary: AttendanceSummaryModel.fromJson(
        json['summary'] is Map<String, dynamic>
            ? json['summary'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
      days: calendar.whereType<Map>().map((item) {
        final dayJson = Map<String, dynamic>.from(item);
        final date = dayJson['date']?.toString() ?? '';
        return AttendanceDayModel.fromJson(dayJson, attendanceMap[date]);
      }).toList(),
    );
  }

  static Map<String, Map<String, dynamic>> _attendanceByDate(dynamic value) {
    if (value is! List) return {};
    final result = <String, Map<String, dynamic>>{};
    for (final item in value.whereType<Map>()) {
      final map = Map<String, dynamic>.from(item);
      final date = (map['date'] ?? map['attendance_date'] ?? map['shift_date'])
          ?.toString();
      if (date != null && date.isNotEmpty) result[date] = map;
    }
    return result;
  }
}

class AttendanceMonthModel {
  final String value;
  final String label;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? today;

  const AttendanceMonthModel({
    required this.value,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.today,
  });

  factory AttendanceMonthModel.fromJson(Map<String, dynamic> json) {
    return AttendanceMonthModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? ''),
      endDate: DateTime.tryParse(json['end_date']?.toString() ?? ''),
      today: DateTime.tryParse(json['today']?.toString() ?? ''),
    );
  }
}

class AttendanceDayModel {
  final DateTime date;
  final AttendanceStatus status;
  final String checkIn;
  final String checkOut;
  final int workedMinutes;
  final bool isToday;
  final bool isDayOff;
  final bool hasAttendance;

  const AttendanceDayModel({
    required this.date,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    required this.workedMinutes,
    required this.isToday,
    required this.isDayOff,
    required this.hasAttendance,
  });

  factory AttendanceDayModel.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic>? attendance,
  ) {
    final isToday = json['is_today'] == true;
    final isDayOff = json['is_day_off'] == true;
    final hasAttendance = json['has_attendance'] == true || attendance != null;

    return AttendanceDayModel(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: _parseStatus(json['status']?.toString(), isToday, isDayOff),
      checkIn: _formatTime(
        attendance?['check_in'] ??
            attendance?['clock_in'] ??
            attendance?['start_time'],
      ),
      checkOut: _formatTime(
        attendance?['check_out'] ??
            attendance?['clock_out'] ??
            attendance?['end_time'],
      ),
      workedMinutes: _asInt(
        attendance?['worked_minutes'] ??
            attendance?['net_minutes'] ??
            attendance?['total_minutes'],
      ),
      isToday: isToday,
      isDayOff: isDayOff,
      hasAttendance: hasAttendance,
    );
  }
}

class AttendanceSummaryModel {
  final int present;
  final int late;
  final int absent;
  final int earlyLeave;
  final int dayOff;

  const AttendanceSummaryModel({
    required this.present,
    required this.late,
    required this.absent,
    required this.earlyLeave,
    this.dayOff = 0,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      present: _asInt(json['present']),
      late: _asInt(json['late']),
      absent: _asInt(json['absent']),
      earlyLeave: _asInt(json['early_leave']),
      dayOff: _asInt(json['day_off']),
    );
  }
}

AttendanceStatus _parseStatus(String? value, bool isToday, bool isDayOff) {
  if (isDayOff) return AttendanceStatus.dayOff;
  if (isToday && (value == null || value == 'none')) {
    return AttendanceStatus.today;
  }

  switch (value) {
    case 'present':
      return AttendanceStatus.present;
    case 'late':
      return AttendanceStatus.late;
    case 'absent':
      return AttendanceStatus.absent;
    case 'early_leave':
    case 'earlyLeave':
      return AttendanceStatus.earlyLeave;
    case 'day_off':
      return AttendanceStatus.dayOff;
    default:
      return isToday ? AttendanceStatus.today : AttendanceStatus.absent;
  }
}

String _formatTime(dynamic value) {
  final rawValue = value?.toString();
  if (rawValue == null || rawValue.isEmpty) return '-';
  final parts = rawValue.split(':');
  if (parts.length < 2) return rawValue;

  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = int.tryParse(parts[1]) ?? 0;
  final suffix = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$displayHour:${minute.toString().padLeft(2, '0')} $suffix';
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
