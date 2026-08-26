import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DeductionTotalCardWidget extends StatelessWidget {
  const DeductionTotalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deductions = context.watch<DeductionsCubit>().deductions;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.errorColor100.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove_circle_outline,
              color: AppColors.errorColor2002,
              size: 24.r,
            ),
          ),
          verticalSpace(8),
          Text(
            context.tr('myEarning.totalDeductions'),
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(6),
          Text(
            formatMoney(
              deductions?.total ?? 0,
              deductions?.currency ?? '',
              minus: true,
            ),
            style: TextStyles.font32greyColor900Weight600.copyWith(
              color: AppColors.errorColor2002,
            ),
          ),
        ],
      ),
    );
  }
}
