import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_cubit.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_state.dart';

class EarningTrendPeriodSwitcherWidget extends StatelessWidget {
  const EarningTrendPeriodSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningTrendCubit, EarningTrendState>(
      buildWhen: (previous, current) =>
          current is EarningTrendPeriodChangedState,
      builder: (context, state) {
        final cubit = context.read<EarningTrendCubit>();
        return Container(
          height: 36.h,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.greyColorFA.withValues(alpha: .7),
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: AppColors.greyColorE5.withValues(alpha: .18),
              width: .8.w,
            ),
          ),
          child: Row(
            children: [
              _TrendPeriodButtonWidget(
                title: context.tr('myEarning.weekly'),
                selected: cubit.selectedPeriod == EarningTrendPeriod.weekly,
                onTap: () => cubit.changePeriod(EarningTrendPeriod.weekly),
              ),
              _TrendPeriodButtonWidget(
                title: context.tr('myEarning.daily'),
                selected: cubit.selectedPeriod == EarningTrendPeriod.daily,
                onTap: () => cubit.changePeriod(EarningTrendPeriod.daily),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrendPeriodButtonWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TrendPeriodButtonWidget({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.whiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.greyColor900.withValues(alpha: .05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style:
                (selected
                        ? TextStyles.font12greyColor900Weight600
                        : TextStyles.font12greyColorA3W400)
                    .copyWith(fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}
