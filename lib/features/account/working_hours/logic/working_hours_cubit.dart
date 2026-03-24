import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/repo/working_hours_repo.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';

class WorkingHoursCubit extends Cubit<WorkingHoursState> {
  final WorkingHoursRepo _workingHoursRepo;

  WorkingHoursCubit(this._workingHoursRepo) : super(WorkingHoursInitialState());

  static WorkingHoursCubit get(context) => BlocProvider.of(context);


  ScrollController myWorkingHoursScrollController = ScrollController();
  List<WorkingHoursModel> myWorkingHours = [];
  int myWorkingHoursCurrentPage = 1;
  late int myWorkingHoursLastPage;

  clearGetAllWorkingHours() {
    myWorkingHoursCurrentPage = 1;
    myWorkingHours = [];
  }

  scrollListenerMyWorkingHoursScrollController() {
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

  getWorkingHours() {
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
              myWorkingHoursLastPage = r.meta!.pagination.lastPage;
          emit(GetWorkingHoursSuccessState());
        },
      );
    })
        .catchError((error) {
      emit(GetWorkingHoursCatchErrorState());
    });
  }

}
