abstract class WorkingHoursState {}

class WorkingHoursInitialState extends WorkingHoursState {}

class GetWorkingHoursLoadingState extends WorkingHoursState {}

class GetWorkingHoursSuccessState extends WorkingHoursState {
  final dynamic data;
  GetWorkingHoursSuccessState(this.data);
}

class GetWorkingHoursErrorState extends WorkingHoursState {
  final String message;
  GetWorkingHoursErrorState(this.message);
}
