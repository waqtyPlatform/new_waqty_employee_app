import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/repo/my_stats_repo.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/logic/my_stats_state.dart';

class MyStatsCubit extends Cubit<MyStatsState> {
  // ignore: unused_field
  final MyStatsRepo _myStatsRepo;

  MyStatsCubit(this._myStatsRepo) : super(InitialState());

  int selectedTabIndex = 0;

  void changeSelectedTab(int index) {
    selectedTabIndex = index;
    emit(InitialState());
  }

  static MyStatsCubit get(context) => BlocProvider.of(context);
}
