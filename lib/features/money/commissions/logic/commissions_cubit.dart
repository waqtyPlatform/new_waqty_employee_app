import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/money/commissions/data/repo/commissions_repo.dart';
import 'package:new_waqty_employee_app/features/money/commissions/logic/commissions_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class CommissionsCubit extends Cubit<CommissionsState> {
  final CommissionsRepo repo;

  CommissionsCubit(this.repo) : super(CommissionsInitialState());

  MoneyCommissionResponse? commissions;
  String languageCode = AppLanguage.currentCode;

  Future<void> init({String? languageCode}) async {
    if (languageCode != null) this.languageCode = languageCode;
    await loadCommissions();
  }

  Future<void> loadCommissions() async {
    emit(CommissionsLoadingState());
    final result = await repo.getCommissions(languageCode: languageCode);
    result.fold((failure) => emit(CommissionsErrorState(failure.message)), (
      response,
    ) {
      commissions = response;
      emit(CommissionsSuccessState());
    });
  }
}
