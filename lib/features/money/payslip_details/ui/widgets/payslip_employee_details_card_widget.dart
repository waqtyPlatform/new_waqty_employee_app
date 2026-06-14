import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/widgets/payslip_detail_row_widget.dart';

class PayslipEmployeeDetailsCardWidget extends StatelessWidget {
  const PayslipEmployeeDetailsCardWidget({super.key});

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
            context.tr('myEarning.employeeDetails'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(10),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.name'),
            value: context.tr('myEarning.employeeName'),
          ),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.employeeId'),
            value: 'EMP-0042',
          ),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.role'),
            value: context.tr('myEarning.employeeRole'),
          ),
          PayslipDetailRowWidget(
            label: context.tr('myEarning.branch'),
            value: context.tr('myEarning.employeeBranch'),
          ),
        ],
      ),
    );
  }
}
