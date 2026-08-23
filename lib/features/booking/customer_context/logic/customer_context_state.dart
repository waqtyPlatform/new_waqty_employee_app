abstract class CustomerContextState {}

class CustomerContextInitialState extends CustomerContextState {}

class CustomerContextLoadingState extends CustomerContextState {}

class CustomerContextSuccessState extends CustomerContextState {}

class CustomerContextErrorState extends CustomerContextState {}

class CustomerPackageAssignLoadingState extends CustomerContextState {}

class CustomerPackageAssignSuccessState extends CustomerContextState {}

class CustomerPackageAssignErrorState extends CustomerContextState {}
