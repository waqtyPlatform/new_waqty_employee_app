import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitialState());

  ProfileResponseModel? profileResponseModel;
  AttendanceSessionModel? currentAttendanceSession;
  AttendanceContextModel? attendanceContext;
  bool isClockedIn = false;
  bool isOnBreak = false;
  bool isCurrentAttendanceLoading = false;
  bool isAttendanceActionLoading = false;
  bool isPresenceConfirmationLoading = false;
  bool isEarlyDepartureRequestLoading = false;
  bool shouldOpenEarlyDepartureRequest = false;
  String attendanceActionErrorMessage = '';
  String attendanceExpectedEndAtErrorMessage = '';
  String presenceConfirmationErrorMessage = '';
  String earlyDepartureRequestErrorMessage = '';

  Future<void> init() async {
    await Future.wait([getProfile(), checkCurrentAttendance()]);
  }

  Future<void> getProfile() async {
    emit(GetProfileLoadingState());
    try {
      final value = await _profileRepo.getProfile();
      value.fold(
        (l) {
          emit(GetProfileErrorState());
        },
        (r) {
          profileResponseModel = r;
          emit(GetProfileSuccessState());
        },
      );
    } catch (error) {
      emit(GetProfileCatchErrorState());
    }
  }

  Future<void> checkCurrentAttendance() async {
    isCurrentAttendanceLoading = true;
    emit(CheckCurrentAttendanceLoadingState());
    try {
      final value = await _profileRepo.checkCurrentAttendance();
      isCurrentAttendanceLoading = false;
      value.fold(
        (l) {
          isClockedIn = false;
          isOnBreak = false;
          currentAttendanceSession = null;
          attendanceContext = null;
          emit(CheckCurrentAttendanceErrorState());
        },
        (r) {
          currentAttendanceSession = r.session;
          attendanceContext = r.context;
          isClockedIn = currentAttendanceSession != null;
          isOnBreak = currentAttendanceSession?.isOnBreak == true;
          emit(CheckCurrentAttendanceSuccessState());
        },
      );
    } catch (error) {
      isCurrentAttendanceLoading = false;
      isClockedIn = false;
      isOnBreak = false;
      currentAttendanceSession = null;
      attendanceContext = null;
      emit(CheckCurrentAttendanceCatchErrorState());
    }
  }

  Future<bool> runAttendanceAction({
    required ProfileAttendanceAction action,
    required double latitude,
    required double longitude,
    String? expectedEndAt,
  }) async {
    if (isAttendanceActionLoading) return false;

    isAttendanceActionLoading = true;
    attendanceActionErrorMessage = '';
    attendanceExpectedEndAtErrorMessage = '';
    shouldOpenEarlyDepartureRequest = false;
    emit(AttendanceActionLoadingState());

    final value = await _profileRepo.runAttendanceAction(
      action: action,
      latitude: latitude,
      longitude: longitude,
      idempotencyKey: _idempotencyKey(action),
      expectedEndAt: expectedEndAt,
    );

    var succeeded = false;
    value.fold(
      (failure) {
        attendanceActionErrorMessage = failure.message;
        if (action == ProfileAttendanceAction.clockIn) {
          final expectedEndAtError = failure.errors['expected_end_at'];
          if (expectedEndAtError is List && expectedEndAtError.isNotEmpty) {
            attendanceExpectedEndAtErrorMessage = expectedEndAtError.first
                .toString();
          } else if (expectedEndAtError != null) {
            attendanceExpectedEndAtErrorMessage = expectedEndAtError.toString();
          }
        }
        shouldOpenEarlyDepartureRequest =
            action == ProfileAttendanceAction.clockOut &&
            (failure.code == 'EARLY_DEPARTURE_APPROVAL_REQUIRED' ||
                failure.meta['next_action']?.toString() ==
                    'request_early_departure');
        emit(AttendanceActionErrorState());
      },
      (session) {
        currentAttendanceSession = action == ProfileAttendanceAction.clockOut
            ? null
            : session;
        isClockedIn = currentAttendanceSession != null;
        isOnBreak = currentAttendanceSession?.isOnBreak == true;
        succeeded = true;
        emit(AttendanceActionSuccessState());
      },
    );

    isAttendanceActionLoading = false;
    await checkCurrentAttendance();
    return succeeded;
  }

  Future<bool> respondPresenceConfirmation({
    required PresenceConfirmationResponse responseValue,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required String locationCapturedAt,
    String? expectedEndAt,
  }) async {
    if (isPresenceConfirmationLoading) return false;

    final session = currentAttendanceSession;
    final confirmation = session?.presenceConfirmation;
    if (session == null ||
        confirmation == null ||
        confirmation.cycleId.isEmpty) {
      return false;
    }

    isPresenceConfirmationLoading = true;
    presenceConfirmationErrorMessage = '';
    emit(PresenceConfirmationLoadingState());

    try {
      final value = await _profileRepo.respondPresenceConfirmation(
        attendanceSessionUuid: session.uuid,
        cycleId: confirmation.cycleId,
        responseValue: responseValue,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        locationCapturedAt: locationCapturedAt,
        expectedEndAt: expectedEndAt,
      );

      var succeeded = false;
      value.fold(
        (failure) {
          presenceConfirmationErrorMessage = failure.message;
          emit(PresenceConfirmationErrorState());
        },
        (updatedSession) {
          currentAttendanceSession = updatedSession.clockOutAt == null
              ? updatedSession
              : null;
          isClockedIn = currentAttendanceSession != null;
          isOnBreak = currentAttendanceSession?.isOnBreak == true;
          succeeded = true;
          emit(PresenceConfirmationSuccessState());
        },
      );

      isPresenceConfirmationLoading = false;
      await checkCurrentAttendance();
      return succeeded;
    } catch (_) {
      presenceConfirmationErrorMessage = 'Presence response failed';
      isPresenceConfirmationLoading = false;
      emit(PresenceConfirmationCatchErrorState());
      await checkCurrentAttendance();
      return false;
    }
  }

  Future<bool> requestEarlyDeparture({required String reason}) async {
    if (isEarlyDepartureRequestLoading) return false;

    final session = currentAttendanceSession;
    if (session == null || session.uuid.isEmpty) return false;

    isEarlyDepartureRequestLoading = true;
    earlyDepartureRequestErrorMessage = '';
    emit(EarlyDepartureRequestLoadingState());

    try {
      final value = await _profileRepo.requestEarlyDeparture(
        attendanceSessionUuid: session.uuid,
        reason: reason,
      );

      var succeeded = false;
      value.fold(
        (failure) {
          earlyDepartureRequestErrorMessage = failure.message;
          emit(EarlyDepartureRequestErrorState());
        },
        (updatedSession) {
          if (updatedSession.uuid.isNotEmpty) {
            currentAttendanceSession = updatedSession.clockOutAt == null
                ? updatedSession
                : null;
            isClockedIn = currentAttendanceSession != null;
            isOnBreak = currentAttendanceSession?.isOnBreak == true;
          }
          succeeded = true;
          emit(EarlyDepartureRequestSuccessState());
        },
      );

      isEarlyDepartureRequestLoading = false;
      await checkCurrentAttendance();
      return succeeded;
    } catch (_) {
      earlyDepartureRequestErrorMessage = 'Early departure request failed';
      isEarlyDepartureRequestLoading = false;
      emit(EarlyDepartureRequestCatchErrorState());
      await checkCurrentAttendance();
      return false;
    }
  }

  String _idempotencyKey(ProfileAttendanceAction action) {
    return '${action.name}-${DateTime.now().millisecondsSinceEpoch}';
  }

  static ProfileCubit get(dynamic context) => BlocProvider.of(context);
}
