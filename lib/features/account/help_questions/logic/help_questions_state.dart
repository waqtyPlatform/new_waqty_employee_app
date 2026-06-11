abstract class HelpQuestionsState {}

class HelpQuestionsInitialState extends HelpQuestionsState {}

class GetFaqsLoadingState extends HelpQuestionsState {}

class GetFaqsSuccessState extends HelpQuestionsState {}

class GetFaqsErrorState extends HelpQuestionsState {}

class GetFaqsCatchErrorState extends HelpQuestionsState {}

class HelpFaqSearchChangedState extends HelpQuestionsState {}

class HelpFaqExpandedChangedState extends HelpQuestionsState {}
