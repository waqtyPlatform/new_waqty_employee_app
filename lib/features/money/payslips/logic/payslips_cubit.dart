import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/repo/payslips_repo.dart';
import 'package:new_waqty_employee_app/features/money/payslips/logic/payslips_state.dart';

class PayslipsCubit extends Cubit<PayslipsState> {
  final PayslipsRepo repo;

  PayslipsCubit(this.repo) : super(PayslipsInitialState());
}
