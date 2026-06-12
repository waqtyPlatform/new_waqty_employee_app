enum AttendanceStatus { present, late, absent, earlyLeave, today }

class AttendanceDayModel {
  final DateTime date;
  final AttendanceStatus status;
  final String checkIn;
  final String checkOut;
  final int workedMinutes;

  const AttendanceDayModel({
    required this.date,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    required this.workedMinutes,
  });
}

class AttendanceSummaryModel {
  final int present;
  final int late;
  final int absent;
  final int earlyLeave;

  const AttendanceSummaryModel({
    required this.present,
    required this.late,
    required this.absent,
    required this.earlyLeave,
  });
}
