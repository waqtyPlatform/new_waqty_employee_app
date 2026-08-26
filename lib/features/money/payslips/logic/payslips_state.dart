abstract class PayslipsState {}

class PayslipsInitialState extends PayslipsState {}

class PayslipsLoadingState extends PayslipsState {}

class PayslipsLoadingMoreState extends PayslipsState {}

class PayslipsSuccessState extends PayslipsState {}

class PayslipsErrorState extends PayslipsState {
  final String message;

  PayslipsErrorState(this.message);
}
