import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_cubit.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_state.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_all_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_categories_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_how_it_works_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/widgets/bonus_total_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';

class BonusesScreen extends StatelessWidget {
  const BonusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<BonusesCubit, BonusesState>(
          buildWhen: (previous, current) =>
              current is BonusesLoadingState ||
              current is BonusesSuccessState ||
              current is BonusesErrorState,
          builder: (context, state) {
            if (state is BonusesLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.greenColor500,
                ),
              );
            }
            if (state is BonusesErrorState) {
              return _MoneyErrorWidget(
                message: state.message,
                onRetry: () => context.read<BonusesCubit>().loadBonuses(),
              );
            }
            return RefreshIndicator(
              color: AppColors.greenColor500,
              onRefresh: () => context.read<BonusesCubit>().loadBonuses(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
                child: Column(
                  children: [
                    const PayslipHeaderWidget(titleKey: 'myEarning.bonuses'),
                    verticalSpace(16),
                    const BonusTotalCardWidget(),
                    verticalSpace(12),
                    const BonusCategoriesCardWidget(),
                    verticalSpace(12),
                    const BonusAllCardWidget(),
                    verticalSpace(12),
                    const BonusHowItWorksCardWidget(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MoneyErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MoneyErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            verticalSpace(12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor500,
              ),
              child: Text(context.tr('myEarning.retry')),
            ),
          ],
        ),
      ),
    );
  }
}
