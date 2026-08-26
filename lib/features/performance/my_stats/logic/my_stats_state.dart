abstract class MyStatsState {}

class InitialState extends MyStatsState {}

class OnMyStatsLoadingState extends MyStatsState {}

class OnMyStatsSuccessState extends MyStatsState {}

class OnMyStatsErrorState extends MyStatsState {
  final String message;

  OnMyStatsErrorState({this.message = ''});
}

class OnMyStatsCatchErrorState extends MyStatsState {
  final String message;

  OnMyStatsCatchErrorState({this.message = ''});
}
