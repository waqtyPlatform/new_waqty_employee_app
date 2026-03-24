 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/logic/profile_details_state.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  final ProfileRepo _profileRepo;

  ProfileDetailsCubit(this._profileRepo) : super(ProfileDetailsInitialState());



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
              emit(GetProfileSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(GetProfileCatchErrorState());
        });
  }

  static ProfileDetailsCubit get(context) => BlocProvider.of(context);
}
