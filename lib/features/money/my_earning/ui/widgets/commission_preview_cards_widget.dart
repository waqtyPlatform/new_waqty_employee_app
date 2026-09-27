import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class CommissionPreviewCardsWidget extends StatelessWidget {
  const CommissionPreviewCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = context.watch<MyEarningCubit>().preview;
    final summaries = preview?.commissionSummaries ?? const [];
    if (summaries.isEmpty) return const SizedBox.shrink();

    return Column(
      children: List.generate(
        summaries.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index == summaries.length - 1 ? 0 : 10.h,
          ),
          child: _CommissionPreviewCardWidget(summary: summaries[index]),
        ),
      ),
    );
  }
}

class _CommissionPreviewCardWidget extends StatelessWidget {
  final MoneyPreviewCommissionSummary summary;

  const _CommissionPreviewCardWidget({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: AppColors.greenColor500.withValues(alpha: .08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.greenColor500,
                  size: 18.r,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('myEarning.yourCommission'),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                    verticalSpace(3),
                    Text(
                      summary.money(summary.total),
                      style: TextStyles.font24greyColor900Weight600.copyWith(
                        color: AppColors.greenColor500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: _CommissionMiniStatWidget(
                  label: context.tr('myEarning.receivedAmount'),
                  value: summary.money(summary.paid),
                  color: AppColors.greenColor500,
                ),
              ),
              horizontalSpace(8),
              Expanded(
                child: _CommissionMiniStatWidget(
                  label: context.tr('myEarning.remainingAmount'),
                  value: summary.money(summary.remaining),
                  color: AppColors.warningColor1001,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommissionMiniStatWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CommissionMiniStatWidget({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W600,
          ),
          verticalSpace(4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font12greyColor900Weight600.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
