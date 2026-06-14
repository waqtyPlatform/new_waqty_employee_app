import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/repo/daily_earning_details_repo.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_state.dart';

class DailyEarningDetailsCubit extends Cubit<DailyEarningDetailsState> {
  final DailyEarningDetailsRepo repo;

  DailyEarningDetailsCubit(this.repo)
    : super(DailyEarningDetailsInitialState());
}
