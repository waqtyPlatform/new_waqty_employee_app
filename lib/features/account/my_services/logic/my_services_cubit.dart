import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/models/my_services_response_model.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/repo/my_services_repo.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_state.dart';

class MyServicesCubit extends Cubit<MyServicesState> {
  final MyServicesRepo _myServicesRepo;

  MyServicesCubit(this._myServicesRepo) : super(MyServicesInitialState()) {
    scrollListenerMyServicesScrollController();
  }

  ScrollController myServicesScrollController = ScrollController();
  List<MyServiceModel> myServices = [];
  int myServicesCurrentPage = 1;
  int myServicesLastPage = 1;

  void init() {
    clearGetAllServices();
    getAllServices();
  }

  void clearGetAllServices() {
    myServicesCurrentPage = 1;
    myServices = [];
  }

  void scrollListenerMyServicesScrollController() {
    myServicesScrollController.addListener(() {
      if (myServicesCurrentPage < myServicesLastPage) {
        if (myServicesScrollController.position.pixels ==
            myServicesScrollController.position.maxScrollExtent) {
          myServicesCurrentPage++;
          getAllServices();
        }
      }
    });
  }

  void getAllServices() {
    emit(OnGetAllServicesLoadingState());
    _myServicesRepo
        .getAllServices(myServicesCurrentPage)
        .then((value) {
          value.fold(
            (l) {
              emit(GetMyServicesErrorState());
            },
            (r) {
              myServices.addAll(r.data);
              myServicesLastPage = r.meta!.pagination.lastPage;
              emit(OnGetAllServicesSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(GetMyServicesCatchErrorState());
        });
  }

  @override
  Future<void> close() {
    myServicesScrollController.dispose();
    return super.close();
  }

  static MyServicesCubit get(BuildContext context) => BlocProvider.of(context);
}
