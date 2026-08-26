import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/data/repo/bonuses_repo.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class BonusesCubit extends Cubit<BonusesState> {
  final BonusesRepo repo;

  BonusesCubit(this.repo) : super(BonusesInitialState());

  MoneyBonusResponse? bonuses;
  String languageCode = 'ar';

  Future<void> init({String? languageCode}) async {
    if (languageCode != null) this.languageCode = languageCode;
    await loadBonuses();
  }

  Future<void> loadBonuses() async {
    emit(BonusesLoadingState());
    final result = await repo.getBonuses(languageCode: languageCode);
    result.fold((failure) => emit(BonusesErrorState(failure.message)), (
      response,
    ) {
      bonuses = response;
      emit(BonusesSuccessState());
    });
  }
}
