import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/models/my_reviews_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/repo/my_reviews_repo.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_state.dart';

class MyReviewsCubit extends Cubit<MyReviewsState> {
  final MyReviewsRepo _myReviewsRepo;

  MyReviewsCubit(this._myReviewsRepo) : super(MyReviewsInitialState()) {
    scrollController.addListener(_onScroll);
  }

  final ScrollController scrollController = ScrollController();
  final List<MyReviewModel> reviews = [];
  MyReviewsSummaryModel? reviewsSummary;
  MyReviewsPaginationModel? reviewsPagination;
  int? selectedRating;
  int reviewsPage = 1;
  bool isReviewsLoading = false;
  bool isReviewsLoadingMore = false;
  String reviewsErrorMessage = '';
  String _languageCode = 'ar';

  void init({required String languageCode}) {
    _languageCode = languageCode;
    loadReviews(languageCode: languageCode);
  }

  Future<void> loadReviews({
    required String languageCode,
    int? rating,
    bool refresh = false,
  }) async {
    if (isReviewsLoading) return;
    _languageCode = languageCode;
    selectedRating = rating;
    reviewsPage = 1;
    isReviewsLoading = true;
    if (refresh) reviews.clear();
    emit(OnMyReviewsLoadingState());
    final result = await _myReviewsRepo.getReviews(
      languageCode: languageCode,
      rating: rating,
      page: reviewsPage,
    );
    result.fold(
      (failure) {
        reviewsErrorMessage = failure.message;
        isReviewsLoading = false;
        emit(OnMyReviewsErrorState(message: failure.message));
      },
      (response) {
        reviews
          ..clear()
          ..addAll(response.reviews);
        reviewsSummary = response.summary;
        reviewsPagination = response.pagination;
        reviewsErrorMessage = '';
        isReviewsLoading = false;
        emit(OnMyReviewsSuccessState());
      },
    );
  }

  Future<void> loadMoreReviews({String? languageCode}) async {
    if (isReviewsLoadingMore || reviewsPagination?.hasMore != true) return;
    isReviewsLoadingMore = true;
    emit(OnMyReviewsLoadingMoreState());
    final nextPage = reviewsPage + 1;
    final result = await _myReviewsRepo.getReviews(
      languageCode: languageCode ?? _languageCode,
      rating: selectedRating,
      page: nextPage,
    );
    result.fold(
      (failure) {
        reviewsErrorMessage = failure.message;
        isReviewsLoadingMore = false;
        emit(OnMyReviewsErrorState(message: failure.message));
      },
      (response) {
        reviews.addAll(response.reviews);
        reviewsSummary = response.summary;
        reviewsPagination = response.pagination;
        reviewsPage = nextPage;
        isReviewsLoadingMore = false;
        emit(OnMyReviewsSuccessState());
      },
    );
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      loadMoreReviews();
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  static MyReviewsCubit get(dynamic context) => BlocProvider.of(context);
}
