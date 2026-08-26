import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/repo/my_stats_repo.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/logic/my_stats_state.dart';

class MyStatsCubit extends Cubit<MyStatsState> {
  final MyStatsRepo _myStatsRepo;

  MyStatsCubit(this._myStatsRepo) : super(InitialState());

  int selectedTabIndex = 0;
  String selectedPeriod = 'today';
  MyStatsDataModel? performance;
  String errorMessage = '';

  Future<void> loadPerformance({
    required String languageCode,
    String? period,
  }) async {
    selectedPeriod = period ?? selectedPeriod;
    final periodIndex = _periods.indexOf(selectedPeriod);
    selectedTabIndex = periodIndex < 0 ? 0 : periodIndex;
    emit(OnMyStatsLoadingState());
    final result = await _myStatsRepo.getPerformance(
      period: selectedPeriod,
      languageCode: languageCode,
    );
    result.fold(
      (failure) {
        errorMessage = failure.message;
        emit(OnMyStatsErrorState(message: failure.message));
      },
      (response) {
        performance = response.data;
        errorMessage = '';
        emit(OnMyStatsSuccessState());
      },
    );
  }

  Future<void> refresh({required String languageCode}) {
    return loadPerformance(languageCode: languageCode);
  }

  Future<void> changeSelectedTab(int index, {String? languageCode}) async {
    selectedTabIndex = index;
    final safeIndex = index.clamp(0, _periods.length - 1).toInt();
    selectedPeriod = _periods[safeIndex];
    if (languageCode == null) {
      emit(InitialState());
      return;
    }
    await loadPerformance(languageCode: languageCode, period: selectedPeriod);
  }

  Future<void> changePeriod(String period, {required String languageCode}) {
    return loadPerformance(languageCode: languageCode, period: period);
  }

  static MyStatsCubit get(dynamic context) => BlocProvider.of(context);

  static const List<String> _periods = ['today', 'week', 'month'];
}
