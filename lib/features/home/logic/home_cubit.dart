import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/home/data/repo/home_repo.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(InitialState());

  HomeSummaryModel? summary;
  String languageCode = AppLanguage.currentCode;
  String errorMessage = '';

  void init({String? languageCode}) {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }
    getHomeSummary();
  }

  void getHomeSummary({String? languageCode}) {
    if (languageCode != null) {
      this.languageCode = languageCode;
    }
    emit(OnHomeLoadingState());

    _homeRepo
        .getHomeSummary(languageCode: this.languageCode)
        .then((value) {
          value.fold(
            (failure) {
              errorMessage = failure.message;
              emit(OnHomeErrorState(failure.message));
            },
            (response) {
              summary = response;
              emit(OnHomeSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(OnHomeCatchErrorState());
        });
  }

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);
}
