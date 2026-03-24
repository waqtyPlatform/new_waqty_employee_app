abstract class WorkingHoursState {}

class WorkingHoursInitialState extends WorkingHoursState {}

class GetWorkingHoursLoadingState extends WorkingHoursState {}

class GetWorkingHoursSuccessState extends WorkingHoursState {

}

class GetWorkingHoursErrorState extends WorkingHoursState {

}

class GetWorkingHoursCatchErrorState extends WorkingHoursState {

}
