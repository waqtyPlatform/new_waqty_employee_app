import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/models/attendance_response_model.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitialState());

  DateTime month = DateTime(2026, 2);
  List<AttendanceDayModel> days = [];

  AttendanceSummaryModel get summary {
    return AttendanceSummaryModel(
      present: days
          .where((day) => day.status == AttendanceStatus.present)
          .length,
      late: days.where((day) => day.status == AttendanceStatus.late).length,
      absent: days.where((day) => day.status == AttendanceStatus.absent).length,
      earlyLeave: days
          .where((day) => day.status == AttendanceStatus.earlyLeave)
          .length,
    );
  }

  void loadAttendanceHistory() {
    days = _mockFebruaryHistory();
    emit(AttendanceHistoryLoadedState());
  }

  List<AttendanceDayModel> _mockFebruaryHistory() {
    return [
      _day(1, AttendanceStatus.present, '09:02 AM', '6:01 PM', 539),
      _day(2, AttendanceStatus.present, '8:58 AM', '6:05 PM', 547),
      _day(3, AttendanceStatus.late, '9:35 AM', '6:00 PM', 505),
      _day(4, AttendanceStatus.present, '9:03 AM', '6:03 PM', 540),
      _day(5, AttendanceStatus.present, '9:05 AM', '6:10 PM', 545),
      _day(6, AttendanceStatus.present, '10:01 AM', '8:02 PM', 601),
      _day(7, AttendanceStatus.earlyLeave, '9:00 AM', '5:10 PM', 490),
      _day(8, AttendanceStatus.present, '9:01 AM', '6:00 PM', 539),
      _day(9, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(10, AttendanceStatus.absent, '—', '—', 0),
      _day(11, AttendanceStatus.present, '9:03 AM', '6:00 PM', 537),
      _day(12, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(13, AttendanceStatus.present, '10:02 AM', '7:55 PM', 593),
      _day(14, AttendanceStatus.late, '9:48 AM', '6:00 PM', 492),
      _day(15, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(16, AttendanceStatus.present, '9:03 AM', '6:25 PM', 562),
      _day(17, AttendanceStatus.present, '10:01 AM', '7:58 PM', 597),
      _day(18, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(19, AttendanceStatus.earlyLeave, '9:00 AM', '3:30 PM', 390),
      _day(20, AttendanceStatus.present, '9:03 AM', '6:00 PM', 537),
      _day(22, AttendanceStatus.present, '9:02 AM', '6:01 PM', 539),
      _day(23, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(24, AttendanceStatus.present, '9:05 AM', '6:10 PM', 545),
      _day(25, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(26, AttendanceStatus.present, '10:01 AM', '7:58 PM', 597),
      _day(27, AttendanceStatus.present, '9:00 AM', '6:00 PM', 540),
      _day(28, AttendanceStatus.today, '9:00 AM', '—', 0),
    ];
  }

  AttendanceDayModel _day(
    int day,
    AttendanceStatus status,
    String checkIn,
    String checkOut,
    int workedMinutes,
  ) {
    return AttendanceDayModel(
      date: DateTime(month.year, month.month, day),
      status: status,
      checkIn: checkIn,
      checkOut: checkOut,
      workedMinutes: workedMinutes,
    );
  }

  static AttendanceCubit get(BuildContext context) => BlocProvider.of(context);
}
