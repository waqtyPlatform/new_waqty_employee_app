import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/models/help_questions_response_model.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/repo/help_questions_repo.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/logic/help_questions_state.dart';

class HelpQuestionsCubit extends Cubit<HelpQuestionsState> {
  final HelpQuestionsRepo _helpQuestionsRepo;

  HelpQuestionsCubit(this._helpQuestionsRepo)
      : super(HelpQuestionsInitialState());

  List<HelpQuestionModel> faqs = [];

  void getFaqs(String languageCode) {
    emit(GetFaqsLoadingState());
    _helpQuestionsRepo.getFaqs(languageCode).then((value) {
      value.fold(
        (failure) => emit(GetFaqsErrorState()),
        (response) {
          faqs = response.data;
          emit(GetFaqsSuccessState());
        },
      );
    }).catchError((error) {
      emit(GetFaqsCatchErrorState());
    });
  }

  static HelpQuestionsCubit get(context) => BlocProvider.of(context);
}
