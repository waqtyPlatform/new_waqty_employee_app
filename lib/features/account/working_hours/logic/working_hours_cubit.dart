import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/repo/working_hours_repo.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';

class WorkingHoursCubit extends Cubit<WorkingHoursState> {
  final WorkingHoursRepo _workingHoursRepo;

  WorkingHoursCubit(this._workingHoursRepo) : super(WorkingHoursInitialState());

  static WorkingHoursCubit get(context) => BlocProvider.of(context);

  void getWorkingHours() {
    emit(GetWorkingHoursLoadingState());
    _workingHoursRepo.getWorkingHours(1).then((value) {
      value.fold(
        (failure) => emit(GetWorkingHoursErrorState(failure.message)),
        (data) => emit(GetWorkingHoursSuccessState(data)),
      );
    });
  }
}
