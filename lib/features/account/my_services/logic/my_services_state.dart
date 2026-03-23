abstract class MyServicesState {}

class MyServicesInitialState extends MyServicesState {}

// Get All Services States
class GetAllServicesLoadingState extends MyServicesState {}

class GetAllServicesSuccessState extends MyServicesState {}

class GetAllServicesErrorState extends MyServicesState {}

class GetMyServicesCatchErrorState extends MyServicesState {}
