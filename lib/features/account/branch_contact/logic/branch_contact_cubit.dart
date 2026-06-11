import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/models/branch_contact_response_model.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/repo/branch_contact_repo.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/logic/branch_contact_state.dart';

class BranchContactCubit extends Cubit<BranchContactState> {
  final BranchContactRepo _branchContactRepo;

  BranchContactCubit(this._branchContactRepo)
    : super(BranchContactInitialState());

  BranchContactModel? branchContact;

  void getBranchContact(String languageCode) {
    emit(GetBranchContactLoadingState());
    _branchContactRepo
        .getBranchContact(languageCode)
        .then((value) {
          value.fold((failure) => emit(GetBranchContactErrorState()), (
            response,
          ) {
            branchContact = response.data;
            emit(GetBranchContactSuccessState());
          });
        })
        .catchError((error) {
          emit(GetBranchContactCatchErrorState());
        });
  }

  static BranchContactCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
