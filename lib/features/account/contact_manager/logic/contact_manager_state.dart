abstract class ContactManagerState {}

class ContactManagerInitialState extends ContactManagerState {}

class ContactManagerSubjectChangedState extends ContactManagerState {}

class ContactManagerPriorityChangedState extends ContactManagerState {}

class ContactManagerViewChangedState extends ContactManagerState {}

class SendContactManagerMessageLoadingState extends ContactManagerState {}

class SendContactManagerMessageSuccessState extends ContactManagerState {}

class SendContactManagerMessageErrorState extends ContactManagerState {}

class SendContactManagerMessageCatchErrorState extends ContactManagerState {}

class ContactManagerMessagesLoadingState extends ContactManagerState {}

class ContactManagerMessagesSuccessState extends ContactManagerState {}

class ContactManagerMessagesErrorState extends ContactManagerState {
  final String message;

  ContactManagerMessagesErrorState({this.message = ''});
}

class ContactManagerMessagesPaginationLoadingState
    extends ContactManagerState {}

class ContactManagerMessagesPaginationSuccessState
    extends ContactManagerState {}
