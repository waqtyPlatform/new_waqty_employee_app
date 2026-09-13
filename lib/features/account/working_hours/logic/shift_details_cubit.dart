import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/repo/working_hours_repo.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/shift_details_state.dart';

class ShiftDetailsCubit extends Cubit<ShiftDetailsState> {
  final WorkingHoursRepo _repo;

  ShiftDetailsCubit(this._repo) : super(ShiftDetailsInitialState());

  WorkingHoursModel? shift;
  String shiftId = '';
  String languageCode = AppLanguage.currentCode;

  Future<void> init({
    required String shiftId,
    required String languageCode,
  }) async {
    this.shiftId = shiftId;
    this.languageCode = languageCode;
    await loadShift();
  }

  Future<void> loadShift() async {
    if (shiftId.trim().isEmpty) {
      emit(ShiftDetailsErrorState(message: ''));
      return;
    }
    emit(ShiftDetailsLoadingState());
    final result = await _repo.getShiftDetails(
      shiftId: shiftId,
      languageCode: languageCode,
    );
    result.fold(
      (failure) => emit(ShiftDetailsErrorState(message: failure.message)),
      (response) {
        shift = response;
        emit(ShiftDetailsSuccessState());
      },
    );
  }

  static ShiftDetailsCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
