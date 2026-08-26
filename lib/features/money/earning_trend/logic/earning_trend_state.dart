abstract class EarningTrendState {}

class EarningTrendInitialState extends EarningTrendState {}

class EarningTrendLoadingState extends EarningTrendState {}

class EarningTrendSuccessState extends EarningTrendState {}

class EarningTrendErrorState extends EarningTrendState {
  final String message;

  EarningTrendErrorState(this.message);
}

class EarningTrendPeriodChangedState extends EarningTrendState {}
