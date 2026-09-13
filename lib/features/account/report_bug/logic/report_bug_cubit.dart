import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/models/report_bug_response_model.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/repo/report_bug_repo.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_state.dart';

class ReportBugCubit extends Cubit<ReportBugState> {
  final ReportBugRepo _reportBugRepo;

  ReportBugCubit(this._reportBugRepo) : super(ReportBugInitialState());

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final ScrollController reportsScrollController = ScrollController();
  final List<ReportBugModel> reports = [];

  String selectedCategory = 'appointments';
  String selectedCategoryKey = 'reportBug.appointments';
  String languageCode = AppLanguage.currentCode;
  bool showReports = false;
  int currentPage = 1;
  int lastPage = 1;
  bool isReportsLoading = false;
  bool isPaginationLoading = false;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    reportsScrollController.addListener(_onScroll);
  }

  void changeCategory({required String category, required String categoryKey}) {
    selectedCategory = category;
    selectedCategoryKey = categoryKey;
    emit(ReportBugCategoryChangedState());
  }

  void changeView(bool reportsView) {
    if (showReports == reportsView) return;
    showReports = reportsView;
    emit(ReportBugViewChangedState());
    if (showReports && reports.isEmpty) {
      getReports(refresh: true);
    }
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
            getReports(refresh: true, showLoading: false);
          });
        })
        .catchError((error) {
          emit(SendReportBugCatchErrorState());
        });
  }

  Future<void> refreshReports() async {
    await getReports(refresh: true, showLoading: false);
  }

  Future<void> getReports({
    bool refresh = false,
    bool showLoading = true,
  }) async {
    if (refresh) {
      currentPage = 1;
      lastPage = 1;
      if (showLoading) {
        isReportsLoading = true;
        emit(ReportBugListLoadingState());
      }
    } else {
      if (currentPage >= lastPage || isReportsLoading || isPaginationLoading) {
        return;
      }
      currentPage++;
      isPaginationLoading = true;
      emit(ReportBugListPaginationLoadingState());
    }

    final result = await _reportBugRepo.getReports(
      languageCode: languageCode,
      page: currentPage,
    );

    result.fold(
      (failure) {
        isReportsLoading = false;
        isPaginationLoading = false;
        emit(ReportBugListErrorState(message: failure.message));
      },
      (response) {
        if (refresh) {
          reports
            ..clear()
            ..addAll(response.data);
        } else {
          reports.addAll(response.data);
        }
        lastPage = response.pagination.lastPage;
        isReportsLoading = false;
        isPaginationLoading = false;
        emit(
          refresh
              ? ReportBugListSuccessState()
              : ReportBugListPaginationSuccessState(),
        );
      },
    );
  }

  void _onScroll() {
    if (!reportsScrollController.hasClients || !showReports) return;
    final position = reportsScrollController.position;
    if (currentPage >= lastPage ||
        isReportsLoading ||
        isPaginationLoading ||
        position.maxScrollExtent <= 0) {
      return;
    }
    if (position.pixels >=
        reportsScrollController.position.maxScrollExtent - 120) {
      getReports();
    }
  }

  @override
  Future<void> close() {
    descriptionController.dispose();
    stepsController.dispose();
    reportsScrollController.removeListener(_onScroll);
    reportsScrollController.dispose();
    return super.close();
  }

  static ReportBugCubit get(BuildContext context) => BlocProvider.of(context);
}
