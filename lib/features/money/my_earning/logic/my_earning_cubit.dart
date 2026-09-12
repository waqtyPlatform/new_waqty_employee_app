import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/data/repo/my_earning_repo.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

enum MyEarningPeriod { thisMonth, lastMonth }

class MyEarningCubit extends Cubit<MyEarningState> {
  final MyEarningRepo repo;

  MyEarningCubit(this.repo) : super(MyEarningInitialState());

  MyEarningPeriod selectedPeriod = MyEarningPeriod.thisMonth;
  EmployeeMoneyPreviewModel? preview;
  MoneyTrendModel? weeklyTrend;
  String languageCode = AppLanguage.currentCode;
  String selectedMonth = _monthKey(DateTime.now());
  bool isPreviewLoading = false;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    loadPreview();
  }

  void changePeriod(MyEarningPeriod period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    selectedMonth = _monthKey(
      DateTime(
        DateTime.now().year,
        DateTime.now().month - (period == MyEarningPeriod.lastMonth ? 1 : 0),
      ),
    );
    emit(MyEarningPeriodChangedState());
    loadPreview(showLoading: false);
  }

  Future<void> refresh() => loadPreview(showLoading: false);

  Future<void> loadPreview({bool showLoading = true}) async {
    isPreviewLoading = true;
    if (showLoading && preview == null) {
      emit(MyEarningLoadingState());
    } else {
      emit(MyEarningContentLoadingState());
    }
    final result = await repo.getPreview(
      month: selectedMonth,
      languageCode: languageCode,
    );
    await result.fold(
      (failure) async {
        isPreviewLoading = false;
        emit(MyEarningErrorState(failure.message));
      },
      (response) async {
        preview = response;
        final trendResult = await repo.getTrend(
          period: 'weekly',
          month: selectedMonth,
          languageCode: languageCode,
        );
        trendResult.fold(
          (_) => weeklyTrend = null,
          (trend) => weeklyTrend = trend,
        );
        isPreviewLoading = false;
        emit(MyEarningSuccessState());
      },
    );
  }

  static String _monthKey(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';
}
