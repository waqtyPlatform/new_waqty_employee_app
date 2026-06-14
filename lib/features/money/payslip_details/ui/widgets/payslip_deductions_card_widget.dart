import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_detail_row_widget.dart';

class PayslipDeductionsCardWidget extends StatelessWidget {
  final bool isPaid;

  const PayslipDeductionsCardWidget({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.deductions'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(10),
          if (isPaid)
            Text(
              context.tr('myEarning.noDeductionsThisMonth'),
              style: TextStyles.font14greyColor500W400,
            )
          else ...[
            _DeductionLineWidget(
              title: context.tr('myEarning.lateArrivalPenalty'),
              date: context.tr('myEarning.dec3'),
              amount: '- EGP 60',
              icon: Icons.error_outline,
            ),
            _DeductionLineWidget(
              title: context.tr('myEarning.uniformReplacement'),
              date: context.tr('myEarning.dec11'),
              amount: '- EGP 95',
              icon: Icons.checkroom_outlined,
            ),
            _DeductionLineWidget(
              title: context.tr('myEarning.materialWastage'),
              date: context.tr('myEarning.dec20'),
              amount: '- EGP 95',
              icon: Icons.water_drop_outlined,
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .22)),
            PayslipDetailRowWidget(
              label: context.tr('myEarning.totalDeductions'),
              value: '- EGP 250',
              valueColor: AppColors.errorColor2002,
              isTotal: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _DeductionLineWidget extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final IconData icon;

  const _DeductionLineWidget({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: AppColors.errorColor2003,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.errorColor2002, size: 15.r),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.font14greyColor900Weight500),
                verticalSpace(2),
                Text(date, style: TextStyles.font12greyColorA3W400),
              ],
            ),
          ),
          horizontalSpace(12),
          Text(amount, style: TextStyles.font14errorColor2002W500),
        ],
      ),
    );
  }
}
