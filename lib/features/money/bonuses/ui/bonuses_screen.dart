import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_all_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_categories_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_how_it_works_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_total_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';

class BonusesScreen extends StatelessWidget {
  const BonusesScreen({super.key});

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
              const PayslipHeaderWidget(titleKey: 'myEarning.bonuses'),
              verticalSpace(16),
              const BonusTotalCardWidget(),
              verticalSpace(12),
              const BonusCategoriesCardWidget(),
              verticalSpace(12),
              const BonusAllCardWidget(),
              verticalSpace(12),
              const BonusHowItWorksCardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
