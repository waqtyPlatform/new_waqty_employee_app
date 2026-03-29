abstract class MyServicesState {}

class MyServicesInitialState extends MyServicesState {}

// Get All Services States
class OnGetAllServicesLoadingState extends MyServicesState {}

class OnGetAllServicesSuccessState extends MyServicesState {}

class GetMyServicesErrorState extends MyServicesState {}

class GetMyServicesCatchErrorState extends MyServicesState {}
