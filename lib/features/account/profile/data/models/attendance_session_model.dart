class AttendanceSessionModel {
  final String uuid;
  final String status;
  final String? clockInAt;
  final String? clockOutAt;
  final String? breakStartedAt;

  const AttendanceSessionModel({
    required this.uuid,
    required this.status,
    this.clockInAt,
    this.clockOutAt,
    this.breakStartedAt,
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
