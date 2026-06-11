import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_state.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/widgets/report_bug_body_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_primary_button_widget.dart';

class ReportBugScreen extends StatelessWidget {
  const ReportBugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const AccountSupportHeaderWidget(titleKey: 'reportBug.title'),
            const Expanded(child: ReportBugBodyWidget()),
            BlocConsumer<ReportBugCubit, ReportBugState>(
              listenWhen: (previous, current) =>
                  current is SendReportBugSuccessState ||
                  current is SendReportBugErrorState ||
                  current is SendReportBugCatchErrorState,
              listener: (context, state) {
                final isSuccess = state is SendReportBugSuccessState;
                final messageKey = isSuccess
                    ? 'reportBug.reportSent'
                    : 'reportBug.reportFailed';
                AppConstant.toast(context.tr(messageKey), isSuccess, context);
              },
              buildWhen: (previous, current) =>
                  current is SendReportBugLoadingState ||
                  current is SendReportBugSuccessState ||
                  current is SendReportBugErrorState ||
                  current is SendReportBugCatchErrorState,
              builder: (context, state) {
                return AccountSupportPrimaryButtonWidget(
                  textKey: 'common.sendMessage',
                  icon: Icons.send_outlined,
                  isLoading: state is SendReportBugLoadingState,
                  onTap: () => ReportBugCubit.get(
                    context,
                  ).sendBugReport(context.locale.languageCode),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
