import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_all_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_categories_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_how_it_works_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_previous_months_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_total_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';

class DeductionsScreen extends StatelessWidget {
  const DeductionsScreen({super.key});

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
              const PayslipHeaderWidget(titleKey: 'myEarning.deductions'),
              verticalSpace(16),
              const DeductionTotalCardWidget(),
              verticalSpace(12),
              const DeductionCategoriesCardWidget(),
              verticalSpace(12),
              const DeductionAllCardWidget(),
              verticalSpace(12),
              const DeductionPreviousMonthsCardWidget(),
              verticalSpace(12),
              const DeductionHowItWorksCardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
