abstract class EmployeeSearchState {}

class EmployeeSearchInitialState extends EmployeeSearchState {}

class EmployeeSearchTypingState extends EmployeeSearchState {}

class EmployeeSearchLoadingState extends EmployeeSearchState {}

class EmployeeSearchSuccessState extends EmployeeSearchState {}

class EmployeeSearchErrorState extends EmployeeSearchState {
  final String message;

  EmployeeSearchErrorState(this.message);
}

class EmployeeCustomerAppointmentsLoadingState extends EmployeeSearchState {}

class EmployeeCustomerAppointmentsSuccessState extends EmployeeSearchState {}

class EmployeeCustomerAppointmentsErrorState extends EmployeeSearchState {
  final String message;

  EmployeeCustomerAppointmentsErrorState(this.message);
}
