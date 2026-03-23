import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/repo/my_services_repo.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_state.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_request_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';

class MyServicesCubit extends Cubit<MyServicesState> {
  final MyServicesRepo _myServicesRepo;

  MyServicesCubit(this._myServicesRepo) : super(MyServicesInitialState());

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

  static MyServicesCubit get(context) => BlocProvider.of(context);
}
