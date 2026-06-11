import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/models/help_questions_response_model.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/repo/help_questions_repo.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/logic/help_questions_state.dart';

class HelpQuestionsCubit extends Cubit<HelpQuestionsState> {
  final HelpQuestionsRepo _helpQuestionsRepo;

  HelpQuestionsCubit(this._helpQuestionsRepo)
    : super(HelpQuestionsInitialState());

  final TextEditingController searchController = TextEditingController();
  List<HelpQuestionModel> faqs = [];
  List<HelpQuestionModel> filteredFaqs = [];
  String? expandedFaqUuid;

  void getFaqs(String languageCode) {
    emit(GetFaqsLoadingState());
    _helpQuestionsRepo
        .getFaqs(languageCode)
        .then((value) {
          value.fold((failure) => emit(GetFaqsErrorState()), (response) {
            faqs = response.data;
            _filterFaqs(searchController.text);
            expandedFaqUuid = filteredFaqs.isNotEmpty
                ? filteredFaqs.first.uuid
                : null;
            emit(GetFaqsSuccessState());
          });
        })
        .catchError((error) {
          emit(GetFaqsCatchErrorState());
        });
  }

  void searchFaqs(String value) {
    _filterFaqs(value);
    if (expandedFaqUuid != null &&
        !filteredFaqs.any((faq) => faq.uuid == expandedFaqUuid)) {
      expandedFaqUuid = filteredFaqs.isNotEmpty
          ? filteredFaqs.first.uuid
          : null;
    }
    emit(HelpFaqSearchChangedState());
  }

  void toggleFaq(String uuid) {
    expandedFaqUuid = expandedFaqUuid == uuid ? null : uuid;
    emit(HelpFaqExpandedChangedState());
  }

  void _filterFaqs(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredFaqs = List<HelpQuestionModel>.from(faqs);
      return;
    }

    filteredFaqs = faqs.where((faq) {
      return faq.question.toLowerCase().contains(query) ||
          faq.answer.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  static HelpQuestionsCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
