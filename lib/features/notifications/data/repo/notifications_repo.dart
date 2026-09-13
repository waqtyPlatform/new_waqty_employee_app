import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notifications_response_model.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notifications_service.dart';

class NotificationsRepo {
  final NotificationsService _service;

  NotificationsRepo(this._service);

  Future<Either<Failure, NotificationsResponseModel>> getNotifications({
    required String languageCode,
    required String status,
    required int page,
    int perPage = 20,
    String? type,
    String? category,
  }) async {
    try {
      return Right(
        await _service.getNotifications(
          languageCode: languageCode,
          status: status,
          page: page,
          perPage: perPage,
          type: type,
          category: category,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, NotificationUnreadCountModel>> getUnreadCount({
    required String languageCode,
  }) async {
    try {
      return Right(await _service.getUnreadCount(languageCode: languageCode));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, NotificationInboxItemModel?>> markRead({
    required String uuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _service.markRead(uuid: uuid, languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> markAllRead({
    required String languageCode,
  }) async {
    try {
      return Right(await _service.markAllRead(languageCode: languageCode));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
