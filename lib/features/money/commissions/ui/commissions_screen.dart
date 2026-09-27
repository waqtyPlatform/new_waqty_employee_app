import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/commissions/logic/commissions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/commissions/logic/commissions_state.dart';
import 'package:new_waqty_employee_app/features/money/commissions/ui/widgets/commission_all_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/commissions/ui/widgets/commission_total_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';

class CommissionsScreen extends StatelessWidget {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<CommissionsCubit, CommissionsState>(
          buildWhen: (previous, current) =>
              current is CommissionsLoadingState ||
              current is CommissionsSuccessState ||
              current is CommissionsErrorState,
          builder: (context, state) {
            if (state is CommissionsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.greenColor500,
                ),
              );
            }
            if (state is CommissionsErrorState) {
              return _MoneyErrorWidget(
                message: state.message,
                onRetry: () =>
                    context.read<CommissionsCubit>().loadCommissions(),
              );
            }
            return RefreshIndicator(
              color: AppColors.greenColor500,
              onRefresh: () =>
                  context.read<CommissionsCubit>().loadCommissions(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
                child: Column(
                  children: [
                    const PayslipHeaderWidget(
                      titleKey: 'myEarning.commissions',
                    ),
                    verticalSpace(16),
                    const CommissionTotalCardWidget(),
                    verticalSpace(12),
                    const CommissionAllCardWidget(),
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
