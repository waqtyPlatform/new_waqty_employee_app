import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslips/ui/widgets/payslips_list_widget.dart';

class PayslipsScreen extends StatelessWidget {
  const PayslipsScreen({super.key});

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
              const PayslipHeaderWidget(titleKey: 'myEarning.payslips'),
              verticalSpace(16),
              const PayslipsListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
