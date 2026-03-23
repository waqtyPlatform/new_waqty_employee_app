import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/models/my_services_response_model.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/repo/my_services_repo.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_state.dart';

class MyServicesCubit extends Cubit<MyServicesState> {
  final MyServicesRepo _myServicesRepo;

  MyServicesCubit(this._myServicesRepo) : super(MyServicesInitialState());

  List<MyServiceModel> myServices = [];

  Future<void> getAllServices() async {
    emit(GetAllServicesLoadingState());
    _myServicesRepo
        .getAllServices()
        .then((value) {
          value.fold(
            (l) {
              emit(GetAllServicesErrorState());
            },
            (r) {
              myServices = r.data;
              emit(GetAllServicesSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(GetMyServicesCatchErrorState());
        });
  }

  static MyServicesCubit get(context) => BlocProvider.of(context);
}
