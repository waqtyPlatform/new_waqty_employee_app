abstract class ShiftDetailsState {}

class ShiftDetailsInitialState extends ShiftDetailsState {}

class ShiftDetailsLoadingState extends ShiftDetailsState {}

class ShiftDetailsSuccessState extends ShiftDetailsState {}

class ShiftDetailsErrorState extends ShiftDetailsState {
  final String message;

  ShiftDetailsErrorState({required this.message});
}
