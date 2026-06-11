import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/models/branch_contact_response_model.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class BranchOpeningHoursWidget extends StatelessWidget {
  final BranchContactModel branchContact;

  const BranchOpeningHoursWidget({super.key, required this.branchContact});

  static const List<_BranchDayData> _days = [
    _BranchDayData(code: 'sun', nameKey: 'branchContact.sun'),
    _BranchDayData(code: 'mon', nameKey: 'branchContact.mon'),
    _BranchDayData(code: 'tue', nameKey: 'branchContact.tue'),
    _BranchDayData(code: 'wed', nameKey: 'branchContact.wed'),
    _BranchDayData(code: 'thu', nameKey: 'branchContact.thu'),
    _BranchDayData(code: 'fri', nameKey: 'branchContact.fri'),
    _BranchDayData(code: 'sat', nameKey: 'branchContact.sat'),
  ];

  @override
  Widget build(BuildContext context) {
    final workingDays = branchContact.workingDays.toSet();
    final hoursDisplay = branchContact.hoursDisplay?.trim().isNotEmpty == true
        ? branchContact.hoursDisplay!
        : context.tr('branchContact.closed');

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
            children: List.generate(_days.length, (index) {
              final day = _days[index];
              final isWorkingDay = workingDays.contains(day.code);
              return _OpeningHourRow(
                day: context.tr(day.nameKey),
                time: isWorkingDay
                    ? hoursDisplay
                    : context.tr('branchContact.closed'),
                isClosed: !isWorkingDay,
                showDivider: index != _days.length - 1,
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
  final bool isClosed;
  final bool showDivider;

  const _OpeningHourRow({
    required this.day,
    required this.time,
    required this.isClosed,
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
              color: isClosed ? AppColors.greyColorA3 : AppColors.greyColor900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchDayData {
  final String code;
  final String nameKey;

  const _BranchDayData({required this.code, required this.nameKey});
}
