abstract class DeductionsState {}

class DeductionsInitialState extends DeductionsState {}

class DeductionsLoadingState extends DeductionsState {}

class DeductionsSuccessState extends DeductionsState {}

class DeductionsErrorState extends DeductionsState {
  final String message;

  DeductionsErrorState(this.message);
}
