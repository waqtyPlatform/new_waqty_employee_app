import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/services/my_services_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_request_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';

class MyServicesRepo {
  final MyServicesService _myServicesService;

  MyServicesRepo(this._myServicesService);

  // Future<Either<Failure, ProfileResponseModel>> getProfile() async {
  //   try {
  //     return Right(await _myServicesService.getProfile());
  //   } on ServerException catch (failure) {
  //     return Left(ServerFailure(message: failure.serverFailure.message));
  //   }
  // }
}
