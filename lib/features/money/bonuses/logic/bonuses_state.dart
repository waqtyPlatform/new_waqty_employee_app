abstract class BonusesState {}

class BonusesInitialState extends BonusesState {}

class BonusesLoadingState extends BonusesState {}

class BonusesSuccessState extends BonusesState {}

class BonusesErrorState extends BonusesState {
  final String message;

  BonusesErrorState(this.message);
}
