import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/money/deductions/data/repo/deductions_repo.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class DeductionsCubit extends Cubit<DeductionsState> {
  final DeductionsRepo repo;

  DeductionsCubit(this.repo) : super(DeductionsInitialState());

  MoneyDeductionResponse? deductions;
  String languageCode = AppLanguage.currentCode;

  Future<void> init({String? languageCode}) async {
    if (languageCode != null) this.languageCode = languageCode;
    await loadDeductions();
  }

  Future<void> loadDeductions() async {
    emit(DeductionsLoadingState());
    final result = await repo.getDeductions(languageCode: languageCode);
    result.fold((failure) => emit(DeductionsErrorState(failure.message)), (
      response,
    ) {
      deductions = response;
      emit(DeductionsSuccessState());
    });
  }
}
