import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/models/customer_context_model.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/repo/customer_context_repo.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/logic/customer_context_state.dart';

class CustomerContextCubit extends Cubit<CustomerContextState> {
  final CustomerContextRepo _repo;

  CustomerContextCubit(this._repo) : super(CustomerContextInitialState());

  CustomerContextModel? contextData;
  String errorMessage = '';
  String? assigningPackageUuid;
  String customerUuid = '';
  String languageCode = AppLanguage.currentCode;

  void getCustomerContext({
    required String customerUuid,
    required String languageCode,
  }) {
    this.customerUuid = customerUuid;
    this.languageCode = languageCode;
    if (customerUuid.isEmpty) {
      errorMessage = 'Customer not found';
      emit(CustomerContextErrorState());
      return;
    }
    emit(CustomerContextLoadingState());
    _repo
        .getCustomerContext(
          customerUuid: customerUuid,
          languageCode: languageCode,
        )
        .then((value) {
          value.fold(
            (failure) {
              errorMessage = failure.message;
              emit(CustomerContextErrorState());
            },
            (response) {
              contextData = response.data;
              emit(CustomerContextSuccessState());
            },
          );
        })
        .catchError((error) {
          errorMessage = error.toString();
          emit(CustomerContextErrorState());
        });
  }

  void assignPackage(AssignableCustomerPackageModel package) {
    if (customerUuid.isEmpty || assigningPackageUuid != null) return;
    if (!package.canAssign) return;

    assigningPackageUuid = package.uuid;
    emit(CustomerPackageAssignLoadingState());
    _repo
        .assignPackage(
          customerUuid: customerUuid,
          packageUuid: package.uuid,
          languageCode: languageCode,
        )
        .then((value) {
          value.fold(
            (failure) {
              errorMessage = failure.message;
              assigningPackageUuid = null;
              emit(CustomerPackageAssignErrorState());
            },
            (response) {
              contextData = response.data;
              assigningPackageUuid = null;
              emit(CustomerPackageAssignSuccessState());
              getCustomerContext(
                customerUuid: customerUuid,
                languageCode: languageCode,
              );
            },
          );
        })
        .catchError((error) {
          errorMessage = error.toString();
          assigningPackageUuid = null;
          emit(CustomerPackageAssignErrorState());
        });
  }

  static CustomerContextCubit get(dynamic context) => BlocProvider.of(context);
}
