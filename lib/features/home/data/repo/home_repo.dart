import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/home/data/services/home_service.dart';

class HomeRepo {
  final HomeService _homeService;

  HomeRepo(this._homeService);

  Future<Either<Failure, HomeSummaryModel>> getHomeSummary({
    required String languageCode,
  }) async {
    try {
      return Right(
        await _homeService.getHomeSummary(languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, HomeSnapshotModel>> getTodaySnapshot({
    required String languageCode,
  }) async {
    try {
      return Right(
        await _homeService.getTodaySnapshot(languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, HomeEarningsModel>> getTodayEarnings({
    required String languageCode,
  }) async {
    try {
      return Right(
        await _homeService.getTodayEarnings(languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, List<HomeAppointmentModel>>> getUpcomingAppointments({
    required String languageCode,
    int limit = 5,
  }) async {
    try {
      return Right(
        await _homeService.getUpcomingAppointments(
          languageCode: languageCode,
          limit: limit,
        ),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, HomeReviewModel?>> getLatestReview({
    required String languageCode,
  }) async {
    try {
      return Right(
        await _homeService.getLatestReview(languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
