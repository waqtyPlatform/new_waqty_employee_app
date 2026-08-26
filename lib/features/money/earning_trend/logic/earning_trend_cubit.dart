import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/data/repo/earning_trend_repo.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

enum EarningTrendPeriod { weekly, daily }

class EarningTrendCubit extends Cubit<EarningTrendState> {
  final EarningTrendRepo repo;

  EarningTrendCubit(this.repo) : super(EarningTrendInitialState());

  EarningTrendPeriod selectedPeriod = EarningTrendPeriod.weekly;
  MoneyTrendModel? trend;
  String languageCode = 'ar';
  String selectedMonth = _monthKey(DateTime.now());

  void init({String? languageCode, String? month}) {
    if (languageCode != null) this.languageCode = languageCode;
    if (month != null && month.isNotEmpty) selectedMonth = month;
    loadTrend();
  }

  void changePeriod(EarningTrendPeriod period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    emit(EarningTrendPeriodChangedState());
    loadTrend();
  }

  void refresh() => loadTrend(showLoading: false);

  Future<void> loadTrend({bool showLoading = true}) async {
    if (showLoading) emit(EarningTrendLoadingState());
    final result = await repo.getTrend(
      period: selectedPeriod.name,
      month: selectedMonth,
      languageCode: languageCode,
    );
    result.fold((failure) => emit(EarningTrendErrorState(failure.message)), (
      response,
    ) {
      trend = response;
      emit(EarningTrendSuccessState());
    });
  }

  static String _monthKey(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';
}
