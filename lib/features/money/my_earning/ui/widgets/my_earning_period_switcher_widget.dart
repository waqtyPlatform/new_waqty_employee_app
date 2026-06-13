import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_state.dart';

class MyEarningPeriodSwitcherWidget extends StatelessWidget {
  const MyEarningPeriodSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyEarningCubit, MyEarningState>(
      buildWhen: (previous, current) => current is MyEarningPeriodChangedState,
      builder: (context, state) {
        final cubit = context.read<MyEarningCubit>();
        return Container(
          height: 36.h,
          padding: EdgeInsets.all(4.8.r),
          decoration: BoxDecoration(
            color: AppColors.greyColor25.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: AppColors.greyColor100.withValues(alpha: .1),
              width: .8.w,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _PeriodTabWidget(
                  title: context.tr('myEarning.thisMonth'),
                  selected: cubit.selectedPeriod == MyEarningPeriod.thisMonth,
                  onTap: () => cubit.changePeriod(MyEarningPeriod.thisMonth),
                ),
              ),
              Expanded(
                child: _PeriodTabWidget(
                  title: context.tr('myEarning.lastMonth'),
                  selected: cubit.selectedPeriod == MyEarningPeriod.lastMonth,
                  onTap: () => cubit.changePeriod(MyEarningPeriod.lastMonth),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PeriodTabWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodTabWidget({
    required this.title,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.whiteColor : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.greyColor900.withValues(alpha: .05),
                    blurRadius: 1.5,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyles.font12greyColor900Weight600.copyWith(
            color: selected ? AppColors.greyColor900 : AppColors.greyColorA3,
          ),
        ),
      ),
    );
  }
}
