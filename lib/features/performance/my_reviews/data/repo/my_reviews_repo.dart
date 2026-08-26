import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/models/my_reviews_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/services/my_reviews_service.dart';

class MyReviewsRepo {
  final MyReviewsService _myReviewsService;

  MyReviewsRepo(this._myReviewsService);

  Future<Either<Failure, MyReviewsResponseModel>> getReviews({
    required String languageCode,
    int? rating,
    String? bookingUuid,
    String? fromDate,
    String? toDate,
    bool? active,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      return Right(
        await _myReviewsService.getReviews(
          languageCode: languageCode,
          rating: rating,
          bookingUuid: bookingUuid,
          fromDate: fromDate,
          toDate: toDate,
          active: active,
          page: page,
          perPage: perPage,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
