import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_detail_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/logic/payslip_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipEarningsCardWidget extends StatelessWidget {
  final bool isPaid;

  const PayslipEarningsCardWidget({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<PayslipDetailsCubit>().details;
    final earnings = details?.earnings ?? const <MoneyLineItem>[];

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
          if (earnings.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font14greyColor500W400,
            )
          else
            ...earnings.map(
              (item) => PayslipDetailRowWidget(
                label: item.title,
                value: formatMoney(
                  item.amount,
                  item.currency.isNotEmpty
                      ? item.currency
                      : details?.currency ?? '',
                ),
                icon: _icon(item.type),
              ),
            ),
          Divider(color: AppColors.greyColor1001.withValues(alpha: .22)),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.grossPay'),
            value: details == null
                ? '-'
                : formatMoney(details.grossPay, details.currency),
            valueColor: AppColors.greenColor500,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

IconData _icon(String type) {
  if (type.contains('salary')) return Icons.account_balance_outlined;
  if (type.contains('commission')) return Icons.trending_up;
  if (type.contains('bonus')) return Icons.card_giftcard_outlined;
  return Icons.payments_outlined;
}
