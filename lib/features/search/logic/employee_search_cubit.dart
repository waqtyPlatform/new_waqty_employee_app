import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/search/data/models/employee_search_models.dart';
import 'package:new_waqty_employee_app/features/search/data/repo/employee_search_repo.dart';
import 'package:new_waqty_employee_app/features/search/logic/employee_search_state.dart';

class EmployeeSearchCubit extends Cubit<EmployeeSearchState> {
  final EmployeeSearchRepo _repo;

  EmployeeSearchCubit(this._repo) : super(EmployeeSearchInitialState());

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  int _requestVersion = 0;

  String languageCode = AppLanguage.currentCode;
  String selectedType = 'all';
  String? selectedCustomerUuid;
  String errorMessage = '';
  EmployeeSearchResponseModel? result;
  EmployeeCustomerAppointmentsResponseModel? customerHistory;

  void init(String languageCode) {
    this.languageCode = languageCode;
  }

  void changeType(String type) {
    if (selectedType == type) return;
    selectedType = type;
    selectedCustomerUuid = null;
    customerHistory = null;
    search(searchController.text, immediate: true);
  }

  void search(String value, {bool immediate = false}) {
    _debounce?.cancel();
    final query = value.trim();
    selectedCustomerUuid = null;
    customerHistory = null;

    if (query.length < 2) {
      _requestVersion++;
      result = null;
      emit(EmployeeSearchTypingState());
      return;
    }

    if (immediate) {
      _runSearch(query);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _runSearch(query);
    });
  }

  Future<void> _runSearch(String query) async {
    final version = ++_requestVersion;
    emit(EmployeeSearchLoadingState());
    final response = await _repo.search(
      query: query,
      type: selectedType,
      languageCode: languageCode,
    );
    if (version != _requestVersion) return;

    response.fold(
      (failure) {
        errorMessage = failure.message;
        emit(EmployeeSearchErrorState(failure.message));
      },
      (data) {
        result = data;
        emit(EmployeeSearchSuccessState());
      },
    );
  }

  Future<void> loadCustomerAppointments(String customerUuid) async {
    if (customerUuid.isEmpty) return;
    selectedCustomerUuid = customerUuid;
    customerHistory = null;
    emit(EmployeeCustomerAppointmentsLoadingState());
    final response = await _repo.customerAppointments(
      customerUuid: customerUuid,
      languageCode: languageCode,
    );
    response.fold(
      (failure) {
        errorMessage = failure.message;
        emit(EmployeeCustomerAppointmentsErrorState(failure.message));
      },
      (data) {
        customerHistory = data;
        emit(EmployeeCustomerAppointmentsSuccessState());
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    searchController.dispose();
    return super.close();
  }

  static EmployeeSearchCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
