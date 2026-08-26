import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/models/payslip_model.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/logic/payslip_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipDetailsHeroCardWidget extends StatelessWidget {
  final PayslipDetailsArgs args;

  const PayslipDetailsHeroCardWidget({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<PayslipDetailsCubit>().details;
    final summary = detail?.summary;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.greenColor500,
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.greenColor400, AppColors.greenColor500],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summary?.label.isNotEmpty == true
                      ? summary!.label
                      : args.monthKey,
                  style: TextStyles.font14greyColor900Weight500.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              _PayslipDetailsStatusPillWidget(
                status: summary?.status ?? (args.isPaid ? 'paid' : 'pending'),
              ),
            ],
          ),
          verticalSpace(18),
          Text(
            detail == null
                ? args.amount
                : formatMoney(detail.netPay, detail.currency),
            style: TextStyles.font32greyColor900Weight600.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayslipDetailsStatusPillWidget extends StatelessWidget {
  final String status;

  const _PayslipDetailsStatusPillWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: AppColors.whiteColor.withValues(alpha: .18),
          width: 1.w,
        ),
      ),
      child: Text(
        context.tr('myEarning.$status'),
        style: TextStyles.font10greyColorA3W600.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
