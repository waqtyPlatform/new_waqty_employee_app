abstract class ContactManagerState {}

class ContactManagerInitialState extends ContactManagerState {}

class ContactManagerSubjectChangedState extends ContactManagerState {}

class ContactManagerPriorityChangedState extends ContactManagerState {}

class SendContactManagerMessageLoadingState extends ContactManagerState {}

class SendContactManagerMessageSuccessState extends ContactManagerState {}

class SendContactManagerMessageErrorState extends ContactManagerState {}

class SendContactManagerMessageCatchErrorState extends ContactManagerState {}
