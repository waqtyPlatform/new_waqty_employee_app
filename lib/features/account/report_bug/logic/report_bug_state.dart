abstract class ReportBugState {}

class ReportBugInitialState extends ReportBugState {}

class ReportBugCategoryChangedState extends ReportBugState {}

class SendReportBugLoadingState extends ReportBugState {}

class SendReportBugSuccessState extends ReportBugState {}

class SendReportBugErrorState extends ReportBugState {}

class SendReportBugCatchErrorState extends ReportBugState {}
