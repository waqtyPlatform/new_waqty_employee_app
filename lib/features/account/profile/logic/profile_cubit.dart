import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitialState());

  ProfileResponseModel? profileResponseModel;
  bool isClockedIn = false;
  bool isCurrentAttendanceLoading = false;

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
          emit(CheckCurrentAttendanceErrorState());
        },
        (r) {
          isClockedIn = r;
          emit(CheckCurrentAttendanceSuccessState());
        },
      );
    } catch (error) {
      isCurrentAttendanceLoading = false;
      isClockedIn = false;
      emit(CheckCurrentAttendanceCatchErrorState());
    }
  }

  static ProfileCubit get(dynamic context) => BlocProvider.of(context);
}
