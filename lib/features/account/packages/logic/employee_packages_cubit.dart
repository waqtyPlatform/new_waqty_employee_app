import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/models/employee_package_model.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/repo/employee_packages_repo.dart';
import 'package:new_waqty_employee_app/features/account/packages/logic/employee_packages_state.dart';

class EmployeePackagesCubit extends Cubit<EmployeePackagesState> {
  final EmployeePackagesRepo _repo;

  EmployeePackagesCubit(this._repo) : super(EmployeePackagesInitialState());

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final List<EmployeePackageModel> packages = [];

  EmployeePackageModel? packageDetails;
  String languageCode = AppLanguage.currentCode;
  String search = '';
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isPaginationLoading = false;
  Timer? _searchDebounce;
  int _requestSerial = 0;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    scrollController.addListener(_onScroll);
    getPackages(refresh: true);
  }

  Future<void> initDetails({
    required String uuid,
    required String languageCode,
  }) async {
    this.languageCode = languageCode;
    await getPackageDetails(uuid);
  }

  void onSearchChanged(String value) {
    search = value.trim();
    emit(EmployeePackagesSearchChangedState());
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      getPackages(refresh: true);
    });
  }

  Future<void> refreshPackages() async {
    await getPackages(refresh: true, showLoading: false);
  }

  Future<void> getPackages({
    bool refresh = false,
    bool showLoading = true,
  }) async {
    if (refresh) {
      currentPage = 1;
      lastPage = 1;
      if (showLoading) {
        isLoading = true;
        emit(EmployeePackagesLoadingState());
      }
    } else {
      if (currentPage >= lastPage || isLoading || isPaginationLoading) return;
      currentPage++;
      isPaginationLoading = true;
      emit(EmployeePackagesPaginationLoadingState());
    }

    final requestSerial = ++_requestSerial;
    final result = await _repo.getPackages(
      languageCode: languageCode,
      page: currentPage,
      search: search,
    );
    if (requestSerial != _requestSerial) return;

    result.fold(
      (failure) {
        if (!refresh && currentPage > 1) currentPage--;
        isLoading = false;
        isPaginationLoading = false;
        emit(EmployeePackagesErrorState(message: failure.message));
      },
      (response) {
        if (refresh) {
          packages
            ..clear()
            ..addAll(response.data);
        } else {
          packages.addAll(response.data);
        }
        lastPage = response.pagination.lastPage;
        isLoading = false;
        isPaginationLoading = false;
        emit(
          refresh
              ? EmployeePackagesSuccessState()
              : EmployeePackagesPaginationSuccessState(),
        );
      },
    );
  }

  Future<void> getPackageDetails(String uuid) async {
    packageDetails = null;
    emit(EmployeePackageDetailsLoadingState());
    final result = await _repo.getPackageDetails(
      uuid: uuid,
      languageCode: languageCode,
    );
    result.fold(
      (failure) {
        emit(EmployeePackageDetailsErrorState(message: failure.message));
      },
      (response) {
        packageDetails = response.data;
        if (packageDetails == null) {
          emit(EmployeePackageDetailsErrorState());
        } else {
          emit(EmployeePackageDetailsSuccessState());
        }
      },
    );
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.maxScrollExtent <= 0 ||
        currentPage >= lastPage ||
        isLoading ||
        isPaginationLoading) {
      return;
    }
    if (position.pixels >= position.maxScrollExtent - 140) {
      getPackages();
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    return super.close();
  }

  static EmployeePackagesCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
