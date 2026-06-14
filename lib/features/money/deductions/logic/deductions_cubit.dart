import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/deductions/data/repo/deductions_repo.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_state.dart';

class DeductionsCubit extends Cubit<DeductionsState> {
  final DeductionsRepo repo;

  DeductionsCubit(this.repo) : super(DeductionsInitialState());
}
