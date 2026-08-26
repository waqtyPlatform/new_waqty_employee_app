import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_details_args.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DailyEarningStatsRowWidget extends StatelessWidget {
  final DailyEarningDetailsArgs args;

  const DailyEarningStatsRowWidget({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<DailyEarningDetailsCubit>().details;
    return Row(
      children: [
        Expanded(
          child: _DailyStatCardWidget(
            value: (details?.appointmentsCount ?? 0).toString(),
            label: context.tr('myEarning.appointments'),
            valueColor: AppColors.greenColor500,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _DailyStatCardWidget(
            value: (details?.servicesCount ?? 0).toString(),
            label: context.tr('myEarning.services'),
            valueColor: AppColors.greyColor900,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _DailyStatCardWidget(
            value: details == null
                ? '-'
                : formatMoney(details.serviceValueGenerated, details.currency),
            label: context.tr('myEarning.revenue'),
            valueColor: AppColors.warningColor1001,
          ),
        ),
      ],
    );
  }
}

class _DailyStatCardWidget extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _DailyStatCardWidget({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      alignment: Alignment.center,
      decoration: myEarningCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyles.font14greyColor900Weight600.copyWith(
              color: valueColor,
            ),
          ),
          verticalSpace(4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W600,
          ),
        ],
      ),
    );
  }
}
