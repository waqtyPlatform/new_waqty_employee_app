import 'package:new_waqty_employee_app/core/exceptions/failure.dart';

class ServerException implements Exception {
  final ServerFailure serverFailure;

  const ServerException({required this.serverFailure});
}
