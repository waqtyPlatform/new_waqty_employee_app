import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitialState());

  ProfileResponseModel? profileResponseModel;


  Future<void> getProfile() async {
    emit(GetProfileLoadingState());
    _profileRepo
        .getProfile()
        .then((value) {
      value.fold(
            (l) {
          emit(GetProfileErrorState());
        },
            (r) {
          profileResponseModel = r;
          emit(GetProfileSuccessState( ));
        },
      );
    })
        .catchError((error) {
      emit(GetProfileCatchErrorState());
    });
  }

  static ProfileCubit get(context) => BlocProvider.of(context);
}
