import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_request_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/logic/profile_details_state.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  final ProfileRepo _profileRepo;

  ProfileDetailsCubit(this._profileRepo) : super(ProfileDetailsInitialState());

  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Future<void> getProfile() async {
  //   emit(GetProfileLoadingState());
  //   _profileRepo
  //       .getProfile()
  //       .then((value) {
  //         value.fold(
  //           (l) {
  //             emit(GetProfileErrorState());
  //           },
  //           (r) {
  //             nameController.text = r.customer.name;
  //             emailController.text = r.customer.email;
  //             phoneController.text = r.customer.phone;

  //             emit(
  //               GetProfileSuccessState(
  //                 name: r.customer.name,
  //                 email: r.customer.email,
  //                 phone: r.customer.phone,
  //               ),
  //             );
  //           },
  //         );
  //       })
  //       .catchError((error) {
  //         emit(GetProfileCatchErrorState());
  //       });
  // }

  static ProfileDetailsCubit get(context) => BlocProvider.of(context);
}
