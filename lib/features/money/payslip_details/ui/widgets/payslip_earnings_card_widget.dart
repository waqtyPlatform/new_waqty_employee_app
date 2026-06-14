import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_detail_row_widget.dart';

class PayslipEarningsCardWidget extends StatelessWidget {
  final bool isPaid;

  const PayslipEarningsCardWidget({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final commission = isPaid ? 'EGP 1,870' : 'EGP 1,400';
    final grossPay = isPaid ? 'EGP 5,120' : 'EGP 4,650';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.earnings'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(10),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.basicSalary'),
            value: 'EGP 3,000',
            icon: Icons.account_balance_outlined,
          ),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.commission'),
            value: commission,
            icon: Icons.trending_up,
          ),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.bonus'),
            value: 'EGP 250',
            icon: Icons.card_giftcard_outlined,
          ),
          Divider(color: AppColors.greyColor1001.withValues(alpha: .22)),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.grossPay'),
            value: grossPay,
            valueColor: AppColors.greenColor500,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
