import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/data/repo/payslip_details_repo.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/logic/payslip_details_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipDetailsCubit extends Cubit<PayslipDetailsState> {
  final PayslipDetailsRepo repo;

  PayslipDetailsCubit(this.repo) : super(PayslipDetailsInitialState());

  MoneyPayslipDetailModel? details;
  String languageCode = 'ar';

  Future<void> loadDetails({required String uuid, String? languageCode}) async {
    if (uuid.isEmpty) {
      emit(PayslipDetailsErrorState('Missing payslip id'));
      return;
    }
    if (languageCode != null) this.languageCode = languageCode;
    emit(PayslipDetailsLoadingState());
    final result = await repo.getDetails(
      uuid: uuid,
      languageCode: this.languageCode,
    );
    result.fold((failure) => emit(PayslipDetailsErrorState(failure.message)), (
      response,
    ) {
      details = response;
      emit(PayslipDetailsSuccessState());
    });
  }
}
