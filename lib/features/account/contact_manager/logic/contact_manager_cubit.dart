import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/repo/contact_manager_repo.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';

class ContactManagerCubit extends Cubit<ContactManagerState> {
  final ContactManagerRepo _contactManagerRepo;

  ContactManagerCubit(this._contactManagerRepo)
    : super(ContactManagerInitialState());

  final TextEditingController messageController = TextEditingController();
  String selectedSubject = 'Schedule question';
  String selectedSubjectKey = 'contactManager.scheduleIssue';
  String selectedPriority = 'normal';

  void changeSubject({required String subject, required String subjectKey}) {
    selectedSubject = subject;
    selectedSubjectKey = subjectKey;
    emit(ContactManagerSubjectChangedState());
  }

  void changePriority(String priority) {
    selectedPriority = priority;
    emit(ContactManagerPriorityChangedState());
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
          });
        })
        .catchError((error) {
          emit(SendContactManagerMessageCatchErrorState());
        });
  }

  @override
  Future<void> close() {
    messageController.dispose();
    return super.close();
  }

  static ContactManagerCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
