import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_waqty_employee_app/features/account/attendance/data/models/attendance_response_model.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/repo/attendance_repo.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepo _attendanceRepo;

  AttendanceCubit(this._attendanceRepo) : super(AttendanceInitialState());

  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);
  List<AttendanceDayModel> days = [];
  AttendanceSummaryModel summary = const AttendanceSummaryModel(
    present: 0,
    late: 0,
    absent: 0,
    earlyLeave: 0,
  );
  String languageCode = 'en';

  Future<void> loadAttendanceHistory({String? languageCode}) async {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }

    emit(AttendanceHistoryLoadingState());
    final firstDay = DateTime(month.year, month.month);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final formatter = intl.DateFormat('yyyy-MM-dd');

    final value = await _attendanceRepo.getAttendance(
      dateFrom: formatter.format(firstDay),
      dateTo: formatter.format(lastDay),
      languageCode: this.languageCode,
    );

    value.fold((failure) => emit(AttendanceHistoryErrorState()), (response) {
      final apiMonth = response.data.month.startDate;
      if (apiMonth != null) {
        month = DateTime(apiMonth.year, apiMonth.month);
      }
      days = response.data.days;
      summary = response.data.summary;
      emit(AttendanceHistoryLoadedState());
    });
  }

  static AttendanceCubit get(BuildContext context) => BlocProvider.of(context);
}
