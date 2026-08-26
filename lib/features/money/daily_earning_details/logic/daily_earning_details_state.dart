abstract class DailyEarningDetailsState {}

class DailyEarningDetailsInitialState extends DailyEarningDetailsState {}

class DailyEarningDetailsLoadingState extends DailyEarningDetailsState {}

class DailyEarningDetailsSuccessState extends DailyEarningDetailsState {}

class DailyEarningDetailsErrorState extends DailyEarningDetailsState {
  final String message;

  DailyEarningDetailsErrorState(this.message);
}
