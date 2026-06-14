import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/data/repo/earning_trend_repo.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_state.dart';

enum EarningTrendPeriod { weekly, daily }

class EarningTrendCubit extends Cubit<EarningTrendState> {
  final EarningTrendRepo repo;

  EarningTrendCubit(this.repo) : super(EarningTrendInitialState());

  EarningTrendPeriod selectedPeriod = EarningTrendPeriod.weekly;

  void changePeriod(EarningTrendPeriod period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    emit(EarningTrendPeriodChangedState());
  }
}
