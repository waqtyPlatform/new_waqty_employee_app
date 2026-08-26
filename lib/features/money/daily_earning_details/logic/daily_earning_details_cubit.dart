import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/repo/daily_earning_details_repo.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class DailyEarningDetailsCubit extends Cubit<DailyEarningDetailsState> {
  final DailyEarningDetailsRepo repo;

  DailyEarningDetailsCubit(this.repo)
    : super(DailyEarningDetailsInitialState());

  DailyMoneyDetailModel? details;
  String languageCode = 'ar';
  String selectedDate = '';

  void init({required String date, String? languageCode}) {
    selectedDate = date;
    if (languageCode != null) this.languageCode = languageCode;
    loadDaily();
  }

  Future<void> loadDaily({bool showLoading = true}) async {
    if (selectedDate.isEmpty) {
      emit(DailyEarningDetailsErrorState('Missing earning date'));
      return;
    }
    if (showLoading) emit(DailyEarningDetailsLoadingState());
    final result = await repo.getDaily(
      date: selectedDate,
      languageCode: languageCode,
    );
    result.fold(
      (failure) => emit(DailyEarningDetailsErrorState(failure.message)),
      (response) {
        details = response;
        emit(DailyEarningDetailsSuccessState());
      },
    );
  }
}
