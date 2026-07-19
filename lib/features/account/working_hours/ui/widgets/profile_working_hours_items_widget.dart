import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_duration_formatter.dart';

class ProfileWorkingHoursItemsWidget extends StatelessWidget {
  final WorkingHoursModel items;
  final bool isExpanded;
  final bool showDivider;
  final VoidCallback onTap;

  const ProfileWorkingHoursItemsWidget({
    super.key,
    required this.items,
    required this.isExpanded,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasShift =
        !items.isDayOff &&
        items.startTime.isNotEmpty &&
        items.endTime.isNotEmpty;
    final dayName = _dayName(context, items.shiftDate);
    final dayShort = _dayShort(context, items.shiftDate);
    final shiftDate = _formatShiftDate(items.shiftDate);
    final timeRange = hasShift
        ? '${_formatTime(items.startTime)} - ${_formatTime(items.endTime)}'
        : context.tr('workingHours.noScheduledShift');

    return Column(
      children: [
        InkWell(
          onTap: hasShift ? onTap : null,
          child: Container(
            constraints: BoxConstraints(minHeight: 60.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
            child: Row(
              children: [
                _DayBadgeWidget(dayShort: dayShort, isActive: hasShift),
                horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$dayName - $shiftDate',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font14greyColor900Weight500,
                      ),
                      verticalSpace(2),
                      Text(
                        timeRange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font12greyColorA3W400,
                      ),
                    ],
                  ),
                ),
                horizontalSpace(8),
                hasShift
                    ? _NetHoursWidget(minutes: items.netMinutes)
                    : const _DayOffBadgeWidget(),
                if (hasShift) ...[
                  horizontalSpace(8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.greyColorE5,
                    size: 18.r,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isExpanded && hasShift) _WorkingHoursDetailsWidget(items: items),
        if (showDivider && !isExpanded)
          const Divider(height: 1, color: AppColors.greyColorF5),
      ],
    );
  }
}

class _DayBadgeWidget extends StatelessWidget {
  final String dayShort;
  final bool isActive;

  const _DayBadgeWidget({required this.dayShort, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.r,
      width: 38.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.greenColor5005 : AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        dayShort.toUpperCase(),
        style: TextStyles.font12greyColor900Weight600.copyWith(
          color: isActive ? AppColors.greenColor500 : AppColors.greyColor300,
        ),
      ),
    );
  }
}

class _NetHoursWidget extends StatelessWidget {
  final int minutes;

  const _NetHoursWidget({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          WorkingHoursDurationFormatter.format(minutes),
          style: TextStyles.font14greyColor900Weight500.copyWith(
            color: AppColors.greenColor500,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          context.tr('workingHours.net'),
          style: TextStyles.font10greyColorA3w400.copyWith(
            color: AppColors.greyColor300,
          ),
        ),
      ],
    );
  }
}

class _DayOffBadgeWidget extends StatelessWidget {
  const _DayOffBadgeWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        context.tr('workingHours.dayOff'),
        style: TextStyles.font10greyColorA3W600,
      ),
    );
  }
}

class _WorkingHoursDetailsWidget extends StatelessWidget {
  final WorkingHoursModel items;

  const _WorkingHoursDetailsWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: const BoxDecoration(
        color: AppColors.greyColorFA,
        border: Border(
          top: BorderSide(color: AppColors.greyColorE5, width: .8),
        ),
      ),
      child: Column(
        children: [
          _TimelineBarWidget(items: items),
          verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: _BreakdownCardWidget(
                  title: context.tr('workingHours.breakLabel'),
                  value: WorkingHoursDurationFormatter.format(
                    items.breakMinutes,
                  ),
                  icon: Icons.timer_outlined,
                  color: AppColors.warningColor1001,
                  backgroundColor: AppColors.warningColor0,
                  borderColor: AppColors.warningColor50,
                ),
              ),
              horizontalSpace(6),
              Expanded(
                child: _BreakdownCardWidget(
                  title: context.tr('workingHours.shift'),
                  value: WorkingHoursDurationFormatter.format(
                    items.shiftMinutes,
                  ),
                  icon: Icons.schedule_outlined,
                  color: AppColors.greyColorA3,
                  backgroundColor: AppColors.whiteColor,
                  borderColor: AppColors.greyColorE5,
                ),
              ),
              horizontalSpace(6),
              Expanded(
                child: _BreakdownCardWidget(
                  title: context.tr('workingHours.net'),
                  value: WorkingHoursDurationFormatter.format(items.netMinutes),
                  icon: Icons.check,
                  color: AppColors.greenColor500,
                  backgroundColor: AppColors.greenColor5005,
                  borderColor: AppColors.successColor50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineBarWidget extends StatelessWidget {
  final WorkingHoursModel items;

  const _TimelineBarWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    final shift = items.shiftMinutes == 0 ? 1 : items.shiftMinutes;
    final breakRatio = (items.breakMinutes / shift).clamp(0.0, 1.0);
    final shiftFlex = ((1 - breakRatio) * 50).round().clamp(1, 50).toInt();
    final breakFlex = (breakRatio * 100).round().clamp(1, 100).toInt();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: SizedBox(
            height: 8.h,
            child: Row(
              children: [
                Expanded(
                  flex: shiftFlex,
                  child: Container(color: AppColors.greenColor500),
                ),
                if (items.breakMinutes > 0)
                  Expanded(
                    flex: breakFlex,
                    child: Container(color: AppColors.warningColor1001),
                  ),
                Expanded(
                  flex: shiftFlex,
                  child: Container(color: AppColors.greenColor500),
                ),
              ],
            ),
          ),
        ),
        verticalSpace(4),
        Row(
          children: [
            _TimePointWidget(
              label: context.tr('workingHours.inTime'),
              time: _formatTime(items.startTime),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            const Spacer(),
            if (items.breakStart != null && items.breakEnd != null)
              _BreakPillWidget(
                text:
                    '${_formatTime(items.breakStart!)} - ${_formatTime(items.breakEnd!)}',
              ),
            const Spacer(),
            _TimePointWidget(
              label: context.tr('workingHours.outTime'),
              time: _formatTime(items.endTime),
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
      ],
    );
  }
}

class _TimePointWidget extends StatelessWidget {
  final String label;
  final String time;
  final CrossAxisAlignment crossAxisAlignment;

  const _TimePointWidget({
    required this.label,
    required this.time,
    required this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: TextStyles.font10greyColorA3w400),
        Text(
          time,
          style: TextStyles.font10greyColorA3W600.copyWith(
            color: AppColors.greyColor900,
          ),
        ),
      ],
    );
  }
}

class _BreakPillWidget extends StatelessWidget {
  final String text;

  const _BreakPillWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.warningColor0,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.warningColor50, width: .8.w),
      ),
      child: Text(
        text,
        style: TextStyles.font10greyColorA3W600.copyWith(
          color: AppColors.warningColor1001,
        ),
      ),
    );
  }
}

class _BreakdownCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  const _BreakdownCardWidget({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: borderColor, width: .8.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12.r, color: color),
              horizontalSpace(4),
              Text(
                title,
                style: TextStyles.font10greyColorA3W600.copyWith(color: color),
              ),
            ],
          ),
          verticalSpace(4),
          Text(
            value,
            style: TextStyles.font12greyColor900Weight600.copyWith(
              color: color == AppColors.greyColorA3
                  ? AppColors.greyColor900
                  : color,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTime(String value) {
  if (value.isEmpty) {
    return '';
  }
  return AppConstant.convertTo12Hour(value);
}

String _formatShiftDate(String value) {
  return value.trim().isEmpty ? '--' : value;
}

String _dayName(BuildContext context, String date) {
  return context.tr('workingHours.${_dayKey(date)}');
}

String _dayShort(BuildContext context, String date) {
  return context.tr('workingHours.${_dayKey(date)}Short');
}

String _dayKey(String date) {
  final parsedDate = DateTime.tryParse(date);
  switch (parsedDate?.weekday) {
    case DateTime.monday:
      return 'monday';
    case DateTime.tuesday:
      return 'tuesday';
    case DateTime.wednesday:
      return 'wednesday';
    case DateTime.thursday:
      return 'thursday';
    case DateTime.friday:
      return 'friday';
    case DateTime.saturday:
      return 'saturday';
    case DateTime.sunday:
      return 'sunday';
    default:
      return 'monday';
  }
}
