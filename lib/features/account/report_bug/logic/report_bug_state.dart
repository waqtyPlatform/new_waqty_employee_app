abstract class ReportBugState {}

class ReportBugInitialState extends ReportBugState {}

class ReportBugCategoryChangedState extends ReportBugState {}

class ReportBugViewChangedState extends ReportBugState {}

class SendReportBugLoadingState extends ReportBugState {}

class SendReportBugSuccessState extends ReportBugState {}

class SendReportBugErrorState extends ReportBugState {}

class SendReportBugCatchErrorState extends ReportBugState {}

class ReportBugListLoadingState extends ReportBugState {}

class ReportBugListSuccessState extends ReportBugState {}

class ReportBugListErrorState extends ReportBugState {
  final String message;

  ReportBugListErrorState({this.message = ''});
}

class ReportBugListPaginationLoadingState extends ReportBugState {}

class ReportBugListPaginationSuccessState extends ReportBugState {}
