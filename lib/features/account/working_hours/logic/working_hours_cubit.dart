import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/repo/working_hours_repo.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';

class WorkingHoursCubit extends Cubit<WorkingHoursState> {
  final WorkingHoursRepo _workingHoursRepo;

  WorkingHoursCubit(this._workingHoursRepo) : super(WorkingHoursInitialState());

  static WorkingHoursCubit get(BuildContext context) =>
      BlocProvider.of(context);

  ScrollController myWorkingHoursScrollController = ScrollController();
  List<WorkingHoursModel> myWorkingHours = [];
  int myWorkingHoursCurrentPage = 1;
  int myWorkingHoursLastPage = 1;
  String? expandedWorkingHourUuid;

  void clearGetAllWorkingHours() {
    myWorkingHoursCurrentPage = 1;
    myWorkingHours = [];
    myWorkingHoursLastPage = 1;
    expandedWorkingHourUuid = null;
  }

  void scrollListenerMyWorkingHoursScrollController() {
    myWorkingHoursScrollController.addListener(() {
      if (myWorkingHoursCurrentPage < myWorkingHoursLastPage) {
        if (myWorkingHoursScrollController.position.pixels ==
            myWorkingHoursScrollController.position.maxScrollExtent) {
          myWorkingHoursCurrentPage++;
          getWorkingHours();
        }
      }
    });
  }

  void getWorkingHours() {
    emit(GetWorkingHoursLoadingState());
    _workingHoursRepo
        .getWorkingHours(myWorkingHoursCurrentPage)
        .then((value) {
          value.fold(
            (l) {
              emit(GetWorkingHoursErrorState());
            },
            (r) {
              myWorkingHours.addAll(r.data);
              myWorkingHoursLastPage = r.meta.pagination.lastPage;
              expandedWorkingHourUuid ??= myWorkingHours.isNotEmpty
                  ? myWorkingHours.first.uuid
                  : null;
              emit(GetWorkingHoursSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(GetWorkingHoursCatchErrorState());
        });
  }

  void toggleWorkingHour(String uuid) {
    expandedWorkingHourUuid = expandedWorkingHourUuid == uuid ? null : uuid;
    emit(WorkingHoursExpandedChangedState());
  }
}
