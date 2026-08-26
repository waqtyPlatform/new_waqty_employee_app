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

class AttendanceSummaryCardWidget extends StatelessWidget {
  const AttendanceSummaryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final attendance = context.watch<MyEarningCubit>().preview?.attendance;
    if (attendance == null) return const SizedBox.shrink();
    final items = _items(context, attendance);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.attendanceSummary'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(8),
          ...items.map((item) => _AttendanceSummaryItemWidget(item: item)),
        ],
      ),
    );
  }

  List<_AttendanceItem> _items(
    BuildContext context,
    MoneyAttendanceSummary attendance,
  ) => [
    _AttendanceItem(
      context.tr('myEarning.scheduledWorkDays'),
      attendance.scheduledWorkDays,
    ),
    _AttendanceItem(
      context.tr('myEarning.presentDays'),
      attendance.presentDays,
    ),
    _AttendanceItem(context.tr('myEarning.absentDays'), attendance.absentDays),
    _AttendanceItem(
      context.tr('myEarning.paidLeaveDays'),
      attendance.paidLeaveDays,
    ),
    _AttendanceItem(
      context.tr('myEarning.unpaidLeaveDays'),
      attendance.unpaidLeaveDays,
    ),
    _AttendanceItem(context.tr('myEarning.halfDays'), attendance.halfDays),
    _AttendanceItem(
      context.tr('myEarning.lateInstances'),
      attendance.lateInstances,
    ),
    _AttendanceItem(
      context.tr('myEarning.earlyLeaveInstances'),
      attendance.earlyLeaveInstances,
    ),
  ];
}

class _AttendanceSummaryItemWidget extends StatelessWidget {
  final _AttendanceItem item;

  const _AttendanceSummaryItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyColor1001.withValues(alpha: .16),
            width: .8.w,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColorA3W400,
            ),
          ),
          Text(
            item.value.toString(),
            style: TextStyles.font14greenColor500Weight600,
          ),
        ],
      ),
    );
  }
}

class _AttendanceItem {
  final String label;
  final int value;

  const _AttendanceItem(this.label, this.value);
}
