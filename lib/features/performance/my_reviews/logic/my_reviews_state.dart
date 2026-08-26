abstract class MyReviewsState {}

class MyReviewsInitialState extends MyReviewsState {}

class OnMyReviewsLoadingState extends MyReviewsState {}

class OnMyReviewsSuccessState extends MyReviewsState {}

class OnMyReviewsLoadingMoreState extends MyReviewsState {}

class OnMyReviewsErrorState extends MyReviewsState {
  final String message;

  OnMyReviewsErrorState({this.message = ''});
}
