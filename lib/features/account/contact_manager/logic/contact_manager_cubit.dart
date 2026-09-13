import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/models/contact_manager_response_model.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/repo/contact_manager_repo.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';

class ContactManagerCubit extends Cubit<ContactManagerState> {
  final ContactManagerRepo _contactManagerRepo;

  ContactManagerCubit(this._contactManagerRepo)
    : super(ContactManagerInitialState());

  final TextEditingController messageController = TextEditingController();
  final ScrollController messagesScrollController = ScrollController();
  final List<ContactManagerMessageModel> messages = [];

  String selectedSubject = 'Schedule question';
  String selectedSubjectKey = 'contactManager.scheduleIssue';
  String selectedPriority = 'normal';
  String languageCode = AppLanguage.currentCode;
  bool showRequests = false;
  int currentPage = 1;
  int lastPage = 1;
  bool isMessagesLoading = false;
  bool isPaginationLoading = false;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    messagesScrollController.addListener(_onScroll);
  }

  void changeSubject({required String subject, required String subjectKey}) {
    selectedSubject = subject;
    selectedSubjectKey = subjectKey;
    emit(ContactManagerSubjectChangedState());
  }

  void changePriority(String priority) {
    selectedPriority = priority;
    emit(ContactManagerPriorityChangedState());
  }

  void changeView(bool requests) {
    if (showRequests == requests) return;
    showRequests = requests;
    emit(ContactManagerViewChangedState());
    if (showRequests && messages.isEmpty) {
      getMessages(refresh: true);
    }
  }

  void sendMessage(String languageCode) {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      emit(SendContactManagerMessageErrorState());
      return;
    }

    emit(SendContactManagerMessageLoadingState());
    _contactManagerRepo
        .sendMessage(
          subject: selectedSubject,
          message: message,
          priority: selectedPriority,
          languageCode: languageCode,
        )
        .then((value) {
          value.fold((failure) => emit(SendContactManagerMessageErrorState()), (
            response,
          ) {
            messageController.clear();
            emit(SendContactManagerMessageSuccessState());
            getMessages(refresh: true, showLoading: false);
          });
        })
        .catchError((error) {
          emit(SendContactManagerMessageCatchErrorState());
        });
  }

  Future<void> refreshMessages() async {
    await getMessages(refresh: true, showLoading: false);
  }

  Future<void> getMessages({
    bool refresh = false,
    bool showLoading = true,
  }) async {
    if (refresh) {
      currentPage = 1;
      lastPage = 1;
      if (showLoading) {
        isMessagesLoading = true;
        emit(ContactManagerMessagesLoadingState());
      }
    } else {
      if (currentPage >= lastPage || isMessagesLoading || isPaginationLoading) {
        return;
      }
      currentPage++;
      isPaginationLoading = true;
      emit(ContactManagerMessagesPaginationLoadingState());
    }

    final result = await _contactManagerRepo.getMessages(
      languageCode: languageCode,
      page: currentPage,
    );

    result.fold(
      (failure) {
        isMessagesLoading = false;
        isPaginationLoading = false;
        emit(ContactManagerMessagesErrorState(message: failure.message));
      },
      (response) {
        if (refresh) {
          messages
            ..clear()
            ..addAll(response.data);
        } else {
          messages.addAll(response.data);
        }
        lastPage = response.pagination.lastPage;
        isMessagesLoading = false;
        isPaginationLoading = false;
        emit(
          refresh
              ? ContactManagerMessagesSuccessState()
              : ContactManagerMessagesPaginationSuccessState(),
        );
      },
    );
  }

  void _onScroll() {
    if (!messagesScrollController.hasClients || !showRequests) return;
    final position = messagesScrollController.position;
    if (currentPage >= lastPage ||
        isMessagesLoading ||
        isPaginationLoading ||
        position.maxScrollExtent <= 0) {
      return;
    }
    if (position.pixels >= position.maxScrollExtent - 120) {
      getMessages();
    }
  }

  @override
  Future<void> close() {
    messageController.dispose();
    messagesScrollController.removeListener(_onScroll);
    messagesScrollController.dispose();
    return super.close();
  }

  static ContactManagerCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
