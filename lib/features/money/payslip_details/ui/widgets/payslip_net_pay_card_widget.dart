import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_detail_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/logic/payslip_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipNetPayCardWidget extends StatelessWidget {
  final String amount;

  const PayslipNetPayCardWidget({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<PayslipDetailsCubit>().details;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: PayslipDetailRowWidget(
        label: context.tr('myEarning.netPay'),
        value: details == null
            ? amount
            : formatMoney(details.netPay, details.currency),
        valueColor: AppColors.greenColor500,
        isTotal: true,
      ),
    );
  }
}
