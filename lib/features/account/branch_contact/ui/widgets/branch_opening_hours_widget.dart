import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class BranchOpeningHoursWidget extends StatelessWidget {
  const BranchOpeningHoursWidget({super.key});

  static const List<_OpeningHourData> _hours = [
    _OpeningHourData('branchContact.monThu', 'branchContact.monThuTime'),
    _OpeningHourData('branchContact.friSat', 'branchContact.friSatTime'),
    _OpeningHourData('branchContact.sunday', 'branchContact.closed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('branchContact.openingHours'),
          style: TextStyles.font10greyColorA3W600,
        ),
        verticalSpace(8),
        AccountSupportCardWidget(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: List.generate(_hours.length, (index) {
              final item = _hours[index];
              return _OpeningHourRow(
                day: context.tr(item.dayKey),
                time: context.tr(item.timeKey),
                showDivider: index != _hours.length - 1,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _OpeningHourRow extends StatelessWidget {
  final String day;
  final String time;
  final bool showDivider;

  const _OpeningHourRow({
    required this.day,
    required this.time,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.greyColorF5))
            : null,
      ),
      child: Row(
        children: [
          Expanded(child: Text(day, style: TextStyles.font14greyColorA3W400)),
          Text(
            time,
            style: TextStyles.font14greyColor900Weight500.copyWith(
              color: time == context.tr('branchContact.closed')
                  ? AppColors.greyColorA3
                  : AppColors.greyColor900,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpeningHourData {
  final String dayKey;
  final String timeKey;

  const _OpeningHourData(this.dayKey, this.timeKey);
}
