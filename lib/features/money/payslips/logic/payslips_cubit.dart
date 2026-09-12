import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/repo/payslips_repo.dart';
import 'package:new_waqty_employee_app/features/money/payslips/logic/payslips_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipsCubit extends Cubit<PayslipsState> {
  final PayslipsRepo repo;

  PayslipsCubit(this.repo) : super(PayslipsInitialState());

  final List<MoneyPayslipSummary> payslips = [];
  String languageCode = AppLanguage.currentCode;
  int page = 1;
  int lastPage = 1;
  bool isLoadingMore = false;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    loadPayslips();
  }

  Future<void> loadPayslips({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      lastPage = 1;
      payslips.clear();
    }
    emit(PayslipsLoadingState());
    final result = await repo.getPayslips(
      page: page,
      languageCode: languageCode,
    );
    result.fold((failure) => emit(PayslipsErrorState(failure.message)), (
      response,
    ) {
      payslips
        ..clear()
        ..addAll(response.items);
      page = response.currentPage;
      lastPage = response.lastPage;
      emit(PayslipsSuccessState());
    });
  }

  Future<void> loadMore() async {
    if (isLoadingMore || page >= lastPage) return;
    isLoadingMore = true;
    emit(PayslipsLoadingMoreState());
    final result = await repo.getPayslips(
      page: page + 1,
      languageCode: languageCode,
    );
    isLoadingMore = false;
    result.fold((failure) => emit(PayslipsErrorState(failure.message)), (
      response,
    ) {
      payslips.addAll(response.items);
      page = response.currentPage;
      lastPage = response.lastPage;
      emit(PayslipsSuccessState());
    });
  }
}
