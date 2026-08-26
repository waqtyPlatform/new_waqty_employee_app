import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class CommissionTargetCardWidget extends StatelessWidget {
  const CommissionTargetCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final target = context.watch<MyEarningCubit>().preview?.commissionTarget;
    if (target == null || target.target <= 0) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: AppColors.greenColor500.withValues(alpha: .06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.track_changes,
                  size: 14.r,
                  color: AppColors.greenColor500,
                ),
              ),
              horizontalSpace(8),
              Text(
                context.tr('myEarning.commissionTarget'),
                style: TextStyles.font14greyColor900Weight600,
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            '${context.tr('myEarning.serviceValueGenerated')}: ${formatMoney(target.current, target.currency)}',
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: LinearProgressIndicator(
              value: target.progress,
              minHeight: 8.h,
              backgroundColor: AppColors.successColor25,
              color: AppColors.greenColor500,
            ),
          ),
          verticalSpace(6),
          Row(
            children: [
              Text(
                '${(target.progress * 100).round()}%',
                style: TextStyles.font14greyColor900Weight600,
              ),
              const Spacer(),
              Text(
                '${formatMoney(target.current, target.currency)} / ${formatMoney(target.target, target.currency)}',
                style: TextStyles.font12greyColorA3W400,
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            '${context.tr('myEarning.estimatedCommission')}: ${formatMoney(target.expectedCommission, target.currency)}',
            style: TextStyles.font12greyColorA3W400,
          ),
        ],
      ),
    );
  }
}
