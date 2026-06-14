import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/data/repo/my_earning_repo.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_state.dart';

enum MyEarningPeriod { thisMonth, lastMonth }

class MyEarningCubit extends Cubit<MyEarningState> {
  final MyEarningRepo repo;

  MyEarningCubit(this.repo) : super(MyEarningInitialState());

  MyEarningPeriod selectedPeriod = MyEarningPeriod.thisMonth;

  void changePeriod(MyEarningPeriod period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    emit(MyEarningPeriodChangedState());
  }
}
