abstract class CommissionsState {}

class CommissionsInitialState extends CommissionsState {}

class CommissionsLoadingState extends CommissionsState {}

class CommissionsSuccessState extends CommissionsState {}

class CommissionsErrorState extends CommissionsState {
  final String message;

  CommissionsErrorState(this.message);
}
