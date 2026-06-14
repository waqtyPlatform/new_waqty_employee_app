import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/models/payslip_model.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_details_hero_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_download_button_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_earnings_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_employee_details_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_net_pay_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_deductions_card_widget.dart';

class PayslipDetailsScreen extends StatelessWidget {
  final PayslipDetailsArgs args;

  const PayslipDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
          child: Column(
            children: [
              const PayslipHeaderWidget(titleKey: 'myEarning.payslipDetails'),
              verticalSpace(16),
              PayslipDetailsHeroCardWidget(args: args),
              verticalSpace(12),
              const PayslipEmployeeDetailsCardWidget(),
              verticalSpace(12),
              PayslipEarningsCardWidget(isPaid: args.isPaid),
              verticalSpace(12),
              PayslipDeductionsCardWidget(isPaid: args.isPaid),
              verticalSpace(12),
              PayslipNetPayCardWidget(amount: args.amount),
              if (args.isPaid) ...[
                verticalSpace(18),
                const PayslipDownloadButtonWidget(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
