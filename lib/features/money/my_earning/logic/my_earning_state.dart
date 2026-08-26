abstract class MyEarningState {}

class MyEarningInitialState extends MyEarningState {}

class MyEarningLoadingState extends MyEarningState {}

class MyEarningContentLoadingState extends MyEarningState {}

class MyEarningSuccessState extends MyEarningState {}

class MyEarningErrorState extends MyEarningState {
  final String message;

  MyEarningErrorState(this.message);
}

class MyEarningPeriodChangedState extends MyEarningState {}
