abstract class AttendanceState {}

class AttendanceInitialState extends AttendanceState {}

class AttendanceHistoryLoadingState extends AttendanceState {}

class AttendanceHistoryLoadedState extends AttendanceState {}

class AttendanceHistoryErrorState extends AttendanceState {}
