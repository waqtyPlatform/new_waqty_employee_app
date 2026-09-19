abstract class HomeState {}

class InitialState extends HomeState {}

class OnHomeLoadingState extends HomeState {}

class OnHomeSuccessState extends HomeState {}

class OnHomeErrorState extends HomeState {
  final String message;

  OnHomeErrorState(this.message);
}

class OnHomeCatchErrorState extends HomeState {}

class HomeSnapshotLoadingState extends HomeState {}

class HomeSnapshotSuccessState extends HomeState {}

class HomeSnapshotErrorState extends HomeState {
  final String message;

  HomeSnapshotErrorState(this.message);
}

class HomeEarningsLoadingState extends HomeState {}

class HomeEarningsSuccessState extends HomeState {}

class HomeEarningsErrorState extends HomeState {
  final String message;

  HomeEarningsErrorState(this.message);
}

class HomeAppointmentsLoadingState extends HomeState {}

class HomeAppointmentsSuccessState extends HomeState {}

class HomeAppointmentsErrorState extends HomeState {
  final String message;

  HomeAppointmentsErrorState(this.message);
}

class HomeLatestReviewLoadingState extends HomeState {}

class HomeLatestReviewSuccessState extends HomeState {}

class HomeLatestReviewErrorState extends HomeState {
  final String message;

  HomeLatestReviewErrorState(this.message);
}
