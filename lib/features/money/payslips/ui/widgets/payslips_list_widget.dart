import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/models/payslip_model.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class PayslipsListWidget extends StatelessWidget {
  const PayslipsListWidget({super.key});

  static const List<PayslipModel> _payslips = [
    PayslipModel(
      monthKey: 'payslipMarch2026',
      amount: 'EGP 5,350',
      status: PayslipStatus.pending,
    ),
    PayslipModel(
      monthKey: 'payslipFebruary2026',
      amount: 'EGP 5,120',
      status: PayslipStatus.paid,
    ),
    PayslipModel(
      monthKey: 'payslipJanuary2026',
      amount: 'EGP 4,980',
      status: PayslipStatus.paid,
    ),
    PayslipModel(
      monthKey: 'payslipDecember2025',
      amount: 'EGP 4,650',
      status: PayslipStatus.paid,
    ),
    PayslipModel(
      monthKey: 'payslipOctober2025',
      amount: 'EGP 5,200',
      status: PayslipStatus.paid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _payslips
          .map(
            (payslip) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _PayslipListItemWidget(payslip: payslip),
            ),
          )
          .toList(),
    );
  }
}

class _PayslipListItemWidget extends StatelessWidget {
  final PayslipModel payslip;

  const _PayslipListItemWidget({required this.payslip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.payslipDetailsScreen,
        arguments: payslip.toRouteArguments(),
      ),
      child: Container(
        height: 82.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: myEarningCardDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('myEarning.${payslip.monthKey}'),
                    style: TextStyles.font16greyColor900Weight600,
                  ),
                  verticalSpace(6),
                  _PayslipStatusPillWidget(isPaid: payslip.isPaid),
                ],
              ),
            ),
            Text(
              payslip.amount,
              style: TextStyles.font14greenColor500Weight600,
            ),
            horizontalSpace(10),
            Icon(
              Icons.chevron_right,
              color: AppColors.greyColor100,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _PayslipStatusPillWidget extends StatelessWidget {
  final bool isPaid;

  const _PayslipStatusPillWidget({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? AppColors.greenColor500 : AppColors.warningColor1001;
    final background = isPaid
        ? AppColors.greenColor500.withValues(alpha: .08)
        : AppColors.warningColor1002;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        context.tr(isPaid ? 'myEarning.paid' : 'myEarning.pending'),
        style: TextStyles.font10greyColorA3W600.copyWith(color: color),
      ),
    );
  }
}
