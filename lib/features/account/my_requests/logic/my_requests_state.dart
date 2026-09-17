abstract class MyRequestsState {}

class MyRequestsInitialState extends MyRequestsState {}

class MyRequestsTabChangedState extends MyRequestsState {}

class MyRequestsSessionLoadingState extends MyRequestsState {}

class MyRequestsSessionSuccessState extends MyRequestsState {}

class MyRequestsSessionErrorState extends MyRequestsState {
  final String message;

  MyRequestsSessionErrorState(this.message);
}

class MyRequestsReasonChangedState extends MyRequestsState {}

class MyRequestsSubmitLoadingState extends MyRequestsState {}

class MyRequestsSubmitSuccessState extends MyRequestsState {}

class MyRequestsSubmitErrorState extends MyRequestsState {
  final String message;

  MyRequestsSubmitErrorState(this.message);
}
