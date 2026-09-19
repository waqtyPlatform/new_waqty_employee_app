import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/home/data/repo/home_repo.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(InitialState());

  HomeSummaryModel? summary;
  HomeSnapshotModel? snapshot;
  HomeEarningsModel? earnings;
  List<HomeAppointmentModel> appointments = [];
  HomeReviewModel? latestReview;
  String languageCode = AppLanguage.currentCode;
  String errorMessage = '';
  String snapshotError = '';
  String earningsError = '';
  String appointmentsError = '';
  String latestReviewError = '';
  bool isHomeLoading = false;
  bool isSnapshotLoading = false;
  bool isEarningsLoading = false;
  bool isAppointmentsLoading = false;
  bool isLatestReviewLoading = false;

  void init({String? languageCode}) {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }
    getHomeSummary();
    getHomeSections();
  }

  Future<void> getHomeSummary({String? languageCode}) async {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }
    isHomeLoading = true;
    emit(OnHomeLoadingState());

    try {
      final value = await _homeRepo.getHomeSummary(
        languageCode: this.languageCode,
      );
      value.fold(
        (failure) {
          errorMessage = failure.message;
          isHomeLoading = false;
          emit(OnHomeErrorState(failure.message));
        },
        (response) {
          summary = response;
          isHomeLoading = false;
          emit(OnHomeSuccessState());
        },
      );
    } catch (_) {
      isHomeLoading = false;
      emit(OnHomeCatchErrorState());
    }
  }

  Future<void> getHomeSections({String? languageCode}) async {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }
    await Future.wait([
      getTodaySnapshot(),
      getTodayEarnings(),
      getUpcomingAppointments(),
      getLatestReview(),
    ]);
  }

  Future<void> getTodaySnapshot() async {
    isSnapshotLoading = true;
    snapshotError = '';
    emit(HomeSnapshotLoadingState());
    final result = await _homeRepo.getTodaySnapshot(languageCode: languageCode);
    result.fold(
      (failure) {
        snapshotError = failure.message;
        isSnapshotLoading = false;
        emit(HomeSnapshotErrorState(failure.message));
      },
      (response) {
        snapshot = response;
        isSnapshotLoading = false;
        emit(HomeSnapshotSuccessState());
      },
    );
  }

  Future<void> getTodayEarnings() async {
    isEarningsLoading = true;
    earningsError = '';
    emit(HomeEarningsLoadingState());
    final result = await _homeRepo.getTodayEarnings(languageCode: languageCode);
    result.fold(
      (failure) {
        earningsError = failure.message;
        isEarningsLoading = false;
        emit(HomeEarningsErrorState(failure.message));
      },
      (response) {
        earnings = response;
        isEarningsLoading = false;
        emit(HomeEarningsSuccessState());
      },
    );
  }

  Future<void> getUpcomingAppointments() async {
    isAppointmentsLoading = true;
    appointmentsError = '';
    emit(HomeAppointmentsLoadingState());
    final result = await _homeRepo.getUpcomingAppointments(
      languageCode: languageCode,
    );
    result.fold(
      (failure) {
        appointmentsError = failure.message;
        isAppointmentsLoading = false;
        emit(HomeAppointmentsErrorState(failure.message));
      },
      (response) {
        appointments = response;
        isAppointmentsLoading = false;
        emit(HomeAppointmentsSuccessState());
      },
    );
  }

  Future<void> getLatestReview() async {
    isLatestReviewLoading = true;
    latestReviewError = '';
    emit(HomeLatestReviewLoadingState());
    final result = await _homeRepo.getLatestReview(languageCode: languageCode);
    result.fold(
      (failure) {
        latestReviewError = failure.message;
        isLatestReviewLoading = false;
        emit(HomeLatestReviewErrorState(failure.message));
      },
      (response) {
        latestReview = response;
        isLatestReviewLoading = false;
        emit(HomeLatestReviewSuccessState());
      },
    );
  }

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);
}
