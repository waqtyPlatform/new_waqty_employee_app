import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/data/repo/bonuses_repo.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_state.dart';

class BonusesCubit extends Cubit<BonusesState> {
  final BonusesRepo repo;

  BonusesCubit(this.repo) : super(BonusesInitialState());
}
