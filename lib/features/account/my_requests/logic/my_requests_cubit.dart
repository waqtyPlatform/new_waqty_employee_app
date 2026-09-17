import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/data/repo/my_requests_repo.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/logic/my_requests_state.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';

enum MyRequestsTab { earlyDeparture, leave }

class MyRequestsCubit extends Cubit<MyRequestsState> {
  final MyRequestsRepo _myRequestsRepo;

  MyRequestsCubit(this._myRequestsRepo) : super(MyRequestsInitialState());

  final TextEditingController reasonController = TextEditingController();
  MyRequestsTab selectedTab = MyRequestsTab.earlyDeparture;
  String languageCode = AppLanguage.currentCode;
  AttendanceSessionModel? currentSession;
  AttendanceContextModel? attendanceContext;
  String? reasonError;
  bool isSessionLoading = false;
  bool isSubmitting = false;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    getCurrentSession();
  }

  void changeTab(MyRequestsTab tab) {
    if (selectedTab == tab) return;
    selectedTab = tab;
    emit(MyRequestsTabChangedState());
  }

  void onReasonChanged(String value) {
    if (reasonError == null) return;
    reasonError = null;
    emit(MyRequestsReasonChangedState());
  }

  Future<void> getCurrentSession() async {
    if (isSessionLoading) return;
    isSessionLoading = true;
    emit(MyRequestsSessionLoadingState());

    final result = await _myRequestsRepo.getCurrentSession(
      languageCode: languageCode,
    );

    isSessionLoading = false;
    result.fold(
      (failure) => emit(MyRequestsSessionErrorState(failure.message)),
      (response) {
        currentSession = response.session;
        attendanceContext = response.context;
        emit(MyRequestsSessionSuccessState());
      },
    );
  }

  Future<bool> submitEarlyDeparture() async {
    if (isSubmitting || !canSubmitEarlyDeparture) return false;

    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      reasonError = 'myRequests.reasonRequired';
      emit(MyRequestsReasonChangedState());
      return false;
    }
    if (reason.length > 1000) {
      reasonError = 'myRequests.reasonTooLong';
      emit(MyRequestsReasonChangedState());
      return false;
    }

    final session = currentSession;
    if (session == null || session.uuid.isEmpty) {
      reasonError = 'myRequests.noOpenSession';
      emit(MyRequestsReasonChangedState());
      return false;
    }

    isSubmitting = true;
    reasonError = null;
    emit(MyRequestsSubmitLoadingState());

    final result = await _myRequestsRepo.requestEarlyDeparture(
      languageCode: languageCode,
      attendanceSessionUuid: session.uuid,
      reason: reason,
    );

    var success = false;
    result.fold(
      (failure) => emit(MyRequestsSubmitErrorState(failure.message)),
      (_) {
        reasonController.clear();
        success = true;
        emit(MyRequestsSubmitSuccessState());
      },
    );

    isSubmitting = false;
    await getCurrentSession();
    return success;
  }

  bool get canSubmitEarlyDeparture {
    final earlyDeparture = currentSession?.earlyDeparture;
    return currentSession != null &&
        earlyDeparture?.isPending != true &&
        earlyDeparture?.isApproved != true;
  }

  @override
  Future<void> close() {
    reasonController.dispose();
    return super.close();
  }

  static MyRequestsCubit get(BuildContext context) => BlocProvider.of(context);
}
