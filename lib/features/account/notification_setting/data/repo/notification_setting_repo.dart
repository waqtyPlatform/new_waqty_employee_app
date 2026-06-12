import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/models/notification_setting_response_model.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/services/notification_setting_service.dart';

class NotificationSettingRepo {
  final NotificationSettingService _notificationSettingService;

  NotificationSettingRepo(this._notificationSettingService);

  Future<Either<Failure, NotificationSettingResponseModel>>
  getNotificationSettings(String languageCode) async {
    try {
      return Right(
        await _notificationSettingService.getNotificationSettings(languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, NotificationSettingResponseModel>>
  updateNotificationSettings({
    required Map<String, dynamic> body,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _notificationSettingService.updateNotificationSettings(
          body: body,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
