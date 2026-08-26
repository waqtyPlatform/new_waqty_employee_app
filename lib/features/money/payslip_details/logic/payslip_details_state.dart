abstract class PayslipDetailsState {}

class PayslipDetailsInitialState extends PayslipDetailsState {}

class PayslipDetailsLoadingState extends PayslipDetailsState {}

class PayslipDetailsSuccessState extends PayslipDetailsState {}

class PayslipDetailsErrorState extends PayslipDetailsState {
  final String message;

  PayslipDetailsErrorState(this.message);
}
