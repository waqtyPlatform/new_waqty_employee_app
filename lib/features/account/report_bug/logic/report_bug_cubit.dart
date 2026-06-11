import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/repo/report_bug_repo.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_state.dart';

class ReportBugCubit extends Cubit<ReportBugState> {
  final ReportBugRepo _reportBugRepo;

  ReportBugCubit(this._reportBugRepo) : super(ReportBugInitialState());

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  String selectedCategory = 'appointments';
  String selectedCategoryKey = 'reportBug.appointments';

  void changeCategory({required String category, required String categoryKey}) {
    selectedCategory = category;
    selectedCategoryKey = categoryKey;
    emit(ReportBugCategoryChangedState());
  }

  void sendBugReport(String languageCode) {
    final description = descriptionController.text.trim();
    final stepsToReproduce = stepsController.text.trim();

    if (description.isEmpty) {
      emit(SendReportBugErrorState());
      return;
    }

    emit(SendReportBugLoadingState());
    _reportBugRepo
        .sendBugReport(
          category: selectedCategory,
          description: description,
          stepsToReproduce: stepsToReproduce,
          languageCode: languageCode,
        )
        .then((value) {
          value.fold((failure) => emit(SendReportBugErrorState()), (response) {
            descriptionController.clear();
            stepsController.clear();
            emit(SendReportBugSuccessState());
          });
        })
        .catchError((error) {
          emit(SendReportBugCatchErrorState());
        });
  }

  @override
  Future<void> close() {
    descriptionController.dispose();
    stepsController.dispose();
    return super.close();
  }

  static ReportBugCubit get(BuildContext context) => BlocProvider.of(context);
}
