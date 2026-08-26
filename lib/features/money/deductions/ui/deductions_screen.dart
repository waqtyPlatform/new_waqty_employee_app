import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_state.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_all_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_categories_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_how_it_works_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/widgets/deduction_total_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';

class DeductionsScreen extends StatelessWidget {
  const DeductionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<DeductionsCubit, DeductionsState>(
          buildWhen: (previous, current) =>
              current is DeductionsLoadingState ||
              current is DeductionsSuccessState ||
              current is DeductionsErrorState,
          builder: (context, state) {
            if (state is DeductionsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.greenColor500,
                ),
              );
            }
            if (state is DeductionsErrorState) {
              return _MoneyErrorWidget(
                message: state.message,
                onRetry: () => context.read<DeductionsCubit>().loadDeductions(),
              );
            }
            return RefreshIndicator(
              color: AppColors.greenColor500,
              onRefresh: () => context.read<DeductionsCubit>().loadDeductions(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
                child: Column(
                  children: [
                    const PayslipHeaderWidget(titleKey: 'myEarning.deductions'),
                    verticalSpace(16),
                    const DeductionTotalCardWidget(),
                    verticalSpace(12),
                    const DeductionCategoriesCardWidget(),
                    verticalSpace(12),
                    const DeductionAllCardWidget(),
                    verticalSpace(12),
                    const DeductionHowItWorksCardWidget(),
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
