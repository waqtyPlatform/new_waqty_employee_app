import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';

class ProfileRepo {
  final ProfileService _profileService;

  ProfileRepo(this._profileService);

  Future<Either<Failure, ProfileResponseModel>> getProfile() async {
    try {
      return Right(await _profileService.getProfile());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, AttendanceCurrentModel>>
  checkCurrentAttendance() async {
    try {
      return Right(await _profileService.checkCurrentAttendance());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, AttendanceSessionModel>> runAttendanceAction({
    required ProfileAttendanceAction action,
    required double latitude,
    required double longitude,
    required String idempotencyKey,
  }) async {
    try {
      return Right(
        await _profileService.runAttendanceAction(
          action: action,
          latitude: latitude,
          longitude: longitude,
          idempotencyKey: idempotencyKey,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Attendance action failed'));
    }
  }

  Future<Either<Failure, AttendanceSessionModel>> respondPresenceConfirmation({
    required String attendanceSessionUuid,
    required String cycleId,
    required PresenceConfirmationResponse responseValue,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required String locationCapturedAt,
    String? expectedEndAt,
  }) async {
    try {
      return Right(
        await _profileService.respondPresenceConfirmation(
          attendanceSessionUuid: attendanceSessionUuid,
          cycleId: cycleId,
          responseValue: responseValue,
          latitude: latitude,
          longitude: longitude,
          accuracyMeters: accuracyMeters,
          locationCapturedAt: locationCapturedAt,
          expectedEndAt: expectedEndAt,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Presence response failed'));
    }
  }
}
