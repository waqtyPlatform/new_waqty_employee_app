abstract class EmployeePackagesState {}

class EmployeePackagesInitialState extends EmployeePackagesState {}

class EmployeePackagesLoadingState extends EmployeePackagesState {}

class EmployeePackagesSuccessState extends EmployeePackagesState {}

class EmployeePackagesErrorState extends EmployeePackagesState {
  final String message;

  EmployeePackagesErrorState({this.message = ''});
}

class EmployeePackagesPaginationLoadingState extends EmployeePackagesState {}

class EmployeePackagesPaginationSuccessState extends EmployeePackagesState {}

class EmployeePackagesSearchChangedState extends EmployeePackagesState {}

class EmployeePackageDetailsLoadingState extends EmployeePackagesState {}

class EmployeePackageDetailsSuccessState extends EmployeePackagesState {}

class EmployeePackageDetailsErrorState extends EmployeePackagesState {
  final String message;

  EmployeePackageDetailsErrorState({this.message = ''});
}
