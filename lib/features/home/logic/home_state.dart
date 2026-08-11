abstract class HomeState {}

class InitialState extends HomeState {}

class OnHomeLoadingState extends HomeState {}

class OnHomeSuccessState extends HomeState {}

class OnHomeErrorState extends HomeState {
  final String message;

  OnHomeErrorState(this.message);
}

class OnHomeCatchErrorState extends HomeState {}
