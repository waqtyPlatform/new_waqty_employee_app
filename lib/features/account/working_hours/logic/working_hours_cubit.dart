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
  int totalShiftMinutes = 0;
  int totalBreakMinutes = 0;
  int totalNetMinutes = 0;
  bool isGettingWorkingHours = false;
  String? expandedWorkingHourUuid;
  String languageCode = 'en';

  void clearGetAllWorkingHours() {
    myWorkingHoursCurrentPage = 1;
    myWorkingHours = [];
    myWorkingHoursLastPage = 1;
    totalShiftMinutes = 0;
    totalBreakMinutes = 0;
    totalNetMinutes = 0;
    expandedWorkingHourUuid = null;
  }

  void scrollListenerMyWorkingHoursScrollController() {
    myWorkingHoursScrollController.addListener(() {
      if (!isGettingWorkingHours &&
          myWorkingHoursCurrentPage < myWorkingHoursLastPage) {
        if (myWorkingHoursScrollController.position.pixels ==
            myWorkingHoursScrollController.position.maxScrollExtent) {
          myWorkingHoursCurrentPage++;
          getWorkingHours();
        }
      }
    });
  }

  void getWorkingHours({String? languageCode}) {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }
    if (isGettingWorkingHours) {
      return;
    }
    final requestedPage = myWorkingHoursCurrentPage;
    isGettingWorkingHours = true;
    emit(GetWorkingHoursLoadingState());
    _workingHoursRepo
        .getWorkingHours(myWorkingHoursCurrentPage, this.languageCode)
        .then((value) {
          value.fold(
            (l) {
              _rollbackPageOnFailure(requestedPage);
              isGettingWorkingHours = false;
              emit(GetWorkingHoursErrorState());
            },
            (r) {
              myWorkingHours.addAll(r.data);
              // await _calculateWorkingHoursSummary();
              myWorkingHoursLastPage = r.meta.pagination.lastPage;
              expandedWorkingHourUuid ??= myWorkingHours.isNotEmpty
                  ? myWorkingHours.first.uuid
                  : null;
              isGettingWorkingHours = false;


              for (final item in r.data) {
                totalShiftMinutes += item.shiftMinutes;
                totalBreakMinutes += item.breakMinutes;
                totalNetMinutes += item.netMinutes;
              }

              emit(GetWorkingHoursSuccessState());
            },
          );
        })
        .catchError((error) {
          _rollbackPageOnFailure(requestedPage);
          isGettingWorkingHours = false;
          emit(GetWorkingHoursCatchErrorState());
        });
  }

  void toggleWorkingHour(String uuid) {
    expandedWorkingHourUuid = expandedWorkingHourUuid == uuid ? null : uuid;
    emit(WorkingHoursExpandedChangedState());
  }

  // Future<void> _calculateWorkingHoursSummary() async{
  //   // totalShiftMinutes = 0;
  //   // totalBreakMinutes = 0;
  //   // totalNetMinutes = 0;
  //
  //   for (final item in myWorkingHours) {
  //     totalShiftMinutes += item.shiftMinutes;
  //     totalBreakMinutes += item.breakMinutes;
  //     totalNetMinutes += item.netMinutes;
  //   }
  // }

  void _rollbackPageOnFailure(int requestedPage) {
    if (requestedPage > 1 && myWorkingHoursCurrentPage == requestedPage) {
      myWorkingHoursCurrentPage--;
    }
  }
}
