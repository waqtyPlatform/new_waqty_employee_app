import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/data/models/recent_earning_model.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_card_decoration.dart';

class RecentEarningsCardWidget extends StatelessWidget {
  const RecentEarningsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      const RecentEarningModel(
        dateKey: 'recentTue3Mar',
        appointmentsKey: 'appointments7',
        amount: 'EGP 680',
      ),
      const RecentEarningModel(
        dateKey: 'recentMon2Mar',
        appointmentsKey: 'appointments6',
        amount: 'EGP 540',
      ),
      const RecentEarningModel(
        dateKey: 'recentSun1Mar',
        appointmentsKey: 'appointments5',
        amount: 'EGP 420',
      ),
      const RecentEarningModel(
        dateKey: 'recentSat28Feb',
        appointmentsKey: 'appointments6',
        amount: 'EGP 540',
      ),
      const RecentEarningModel(
        dateKey: 'recentFri27Feb',
        appointmentsKey: 'appointments5',
        amount: 'EGP 420',
      ),
      const RecentEarningModel(
        dateKey: 'recentThu26Feb',
        appointmentsKey: 'appointments7',
        amount: 'EGP 680',
      ),
      const RecentEarningModel(
        dateKey: 'recentWed25Feb',
        appointmentsKey: 'appointments0',
      ),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 6.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.recent'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(8),
          ...items.map((item) => _RecentEarningItemWidget(item: item)),
        ],
      ),
    );
  }
}

class _RecentEarningItemWidget extends StatelessWidget {
  final RecentEarningModel item;

  const _RecentEarningItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyColor100.withValues(alpha: .1),
            width: .8.w,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('myEarning.${item.dateKey}'),
                  style: TextStyles.font14greyColor900Weight500,
                ),
                verticalSpace(2),
                Text(
                  context.tr('myEarning.${item.appointmentsKey}'),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
          if (item.amount == null)
            Text('-', style: TextStyles.font14greyColorA3W400)
          else ...[
            Text(item.amount!, style: TextStyles.font14greenColor500Weight600),
            horizontalSpace(8),
            Icon(
              Icons.chevron_right,
              color: AppColors.greenColor500,
              size: 16.r,
            ),
          ],
        ],
      ),
    );
  }
}
