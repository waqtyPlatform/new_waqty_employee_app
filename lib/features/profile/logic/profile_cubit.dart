import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/profile/data/models/profile_request_model.dart';
import 'package:new_waqty_employee_app/features/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/profile/logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitialState());

  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
              nameController.text = r.customer.name;
              emailController.text = r.customer.email;
              phoneController.text = r.customer.phone;

              emit(
                GetProfileSuccessState(
                  name: r.customer.name,
                  email: r.customer.email,
                  phone: r.customer.phone,
                ),
              );
            },
          );
        })
        .catchError((error) {
          emit(GetProfileCatchErrorState());
        });
  }

  Future<void> updateProfile() async {
    if (!profileKey.currentState!.validate()) return;

    emit(UpdateProfileLoadingState());
    _profileRepo
        .updateProfile(
          ProfileRequestModel(
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
          ),
        )
        .then((value) {
          value.fold(
            (l) {
              emit(UpdateProfileErrorState());
            },
            (r) {
              emit(UpdateProfileSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(UpdateProfileCatchErrorState());
        });
  }

  static ProfileCubit get(context) => BlocProvider.of(context);
}
