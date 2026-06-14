import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/data/repo/payslip_details_repo.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/logic/payslip_details_state.dart';

class PayslipDetailsCubit extends Cubit<PayslipDetailsState> {
  final PayslipDetailsRepo repo;

  PayslipDetailsCubit(this.repo) : super(PayslipDetailsInitialState());
}
