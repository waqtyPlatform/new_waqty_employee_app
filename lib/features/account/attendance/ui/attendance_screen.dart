import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/models/attendance_response_model.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_cubit.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_state.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _didLoadAttendance = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadAttendance) return;
    _didLoadAttendance = true;
    AttendanceCubit.get(
      context,
    ).loadAttendanceHistory(languageCode: context.locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Column(
            children: [
              const _AttendanceHeaderWidget(),
              verticalSpace(16),
              Expanded(
                child: BlocBuilder<AttendanceCubit, AttendanceState>(
                  buildWhen: (previous, current) =>
                      current is AttendanceHistoryLoadingState ||
                      current is AttendanceHistoryLoadedState ||
                      current is AttendanceHistoryErrorState,
                  builder: (context, state) {
                    final cubit = AttendanceCubit.get(context);
                    if (state is AttendanceHistoryLoadingState &&
                        cubit.days.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is AttendanceHistoryErrorState &&
                        cubit.days.isEmpty) {
                      return _AttendanceErrorWidget(
                        onRetry: () => cubit.loadAttendanceHistory(
                          languageCode: context.locale.languageCode,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => cubit.loadAttendanceHistory(
                        languageCode: context.locale.languageCode,
                      ),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _AttendanceSummaryWidget(summary: cubit.summary),
                            verticalSpace(16),
                            _AttendanceCalendarWidget(
                              month: cubit.month,
                              days: cubit.days,
                            ),
                            verticalSpace(16),
                            _AttendanceListWidget(days: cubit.days),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceHeaderWidget extends StatelessWidget {
  const _AttendanceHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(40.r),
              child: Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.greyColor50),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.greyColor900,
                  size: 22.r,
                ),
              ),
            ),
          ),
          Text(
            context.tr('attendance.title'),
            style: TextStyles.font18greyColor900Weight600,
          ),
        ],
      ),
    );
  }
}

class _AttendanceSummaryWidget extends StatelessWidget {
  final AttendanceSummaryModel summary;

  const _AttendanceSummaryWidget({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AttendanceStatCardWidget(
            value: summary.present,
            label: context.tr('attendance.present'),
            color: AppColors.greenColor500,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _AttendanceStatCardWidget(
            value: summary.late,
            label: context.tr('attendance.late'),
            color: AppColors.warningColor1001,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _AttendanceStatCardWidget(
            value: summary.absent,
            label: context.tr('attendance.absent'),
            color: AppColors.errorColor2002,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _AttendanceStatCardWidget(
            value: summary.earlyLeave,
            label: context.tr('attendance.early'),
            color: AppColors.blueColor506,
          ),
        ),
      ],
    );
  }
}

class _AttendanceStatCardWidget extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _AttendanceStatCardWidget({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 93.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyles.font18greyColor900Weight600.copyWith(
              color: color,
              fontSize: 32.sp,
              height: 1,
            ),
          ),
          verticalSpace(8),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W600.copyWith(letterSpacing: .4),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCalendarWidget extends StatelessWidget {
  final DateTime month;
  final List<AttendanceDayModel> days;

  const _AttendanceCalendarWidget({required this.month, required this.days});

  @override
  Widget build(BuildContext context) {
    final dayMap = {for (final item in days) item.date.day: item};
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month).weekday;
    final leadingEmptyCells = firstWeekday - 1;
    final totalCells = leadingEmptyCells + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return _AttendanceCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            intl.DateFormat('MMMM yyyy').format(month),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(day, style: TextStyles.font10greyColorA3W600),
                    ),
                  ),
                )
                .toList(),
          ),
          verticalSpace(8),
          GridView.builder(
            itemCount: rowCount * 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 47.h,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leadingEmptyCells + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }
              return _CalendarDayWidget(
                day: dayNumber,
                status: dayMap[dayNumber]?.status,
              );
            },
          ),
          verticalSpace(8),
          const _AttendanceLegendWidget(),
        ],
      ),
    );
  }
}

class _CalendarDayWidget extends StatelessWidget {
  final int day;
  final AttendanceStatus? status;

  const _CalendarDayWidget({required this.day, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.toString(),
            style: TextStyles.font12greyColor900Weight600.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          verticalSpace(6),
          Container(
            height: 4.r,
            width: 4.r,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceLegendWidget extends StatelessWidget {
  const _AttendanceLegendWidget();

  @override
  Widget build(BuildContext context) {
    final items = [
      _LegendData(context.tr('attendance.present'), AppColors.greenColor500),
      _LegendData(context.tr('attendance.late'), AppColors.warningColor1001),
      _LegendData(context.tr('attendance.absent'), AppColors.errorColor2002),
      _LegendData(context.tr('attendance.early'), AppColors.blueColor506),
      _LegendData(context.tr('attendance.today'), AppColors.greyColor300),
    ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: items
          .map(
            (item) => _LegendItemWidget(label: item.label, color: item.color),
          )
          .toList(),
    );
  }
}

class _AttendanceListWidget extends StatelessWidget {
  final List<AttendanceDayModel> days;

  const _AttendanceListWidget({required this.days});

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return _AttendanceCardWidget(
        child: Center(
          child: Text(
            context.tr('attendance.noRecords'),
            style: TextStyles.font14greyColor900Weight500,
          ),
        ),
      );
    }

    return _AttendanceCardWidget(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(days.length, (index) {
          return _AttendanceHistoryItemWidget(
            item: days[index],
            showDivider: index != days.length - 1,
          );
        }),
      ),
    );
  }
}

class _AttendanceHistoryItemWidget extends StatelessWidget {
  final AttendanceDayModel item;
  final bool showDivider;

  const _AttendanceHistoryItemWidget({
    required this.item,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = intl.DateFormat('MMM d').format(item.date);
    final timeText = !item.hasAttendance
        ? context.tr('attendance.noShift')
        : '${item.checkIn} - ${item.checkOut} · ${_formatDuration(item.workedMinutes)}';

    return Container(
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.greyColorF5))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateText, style: TextStyles.font14greyColor900Weight500),
                verticalSpace(2),
                Text(
                  timeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          _StatusPillWidget(status: item.status),
        ],
      ),
    );
  }
}

class _StatusPillWidget extends StatelessWidget {
  final AttendanceStatus status;

  const _StatusPillWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _statusBgColor(status),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        _statusLabel(context, status),
        style: TextStyles.font10greyColorA3W600.copyWith(color: color),
      ),
    );
  }
}

class _AttendanceCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _AttendanceCardWidget({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LegendItemWidget extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItemWidget({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 4.r,
          width: 4.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        horizontalSpace(4),
        Text(label, style: TextStyles.font10greyColorA3w400),
      ],
    );
  }
}

class _AttendanceErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const _AttendanceErrorWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr('common.errorMessage'),
            style: TextStyles.font14greyColor900Weight500,
          ),
          verticalSpace(12),
          TextButton(
            onPressed: onRetry,
            child: Text(context.tr('common.retry')),
          ),
        ],
      ),
    );
  }
}

class _LegendData {
  final String label;
  final Color color;

  const _LegendData(this.label, this.color);
}

Color _statusColor(AttendanceStatus? status) {
  switch (status) {
    case AttendanceStatus.present:
      return AppColors.greenColor500;
    case AttendanceStatus.late:
      return AppColors.warningColor1001;
    case AttendanceStatus.absent:
      return AppColors.errorColor2002;
    case AttendanceStatus.earlyLeave:
      return AppColors.blueColor506;
    case AttendanceStatus.dayOff:
      return AppColors.greyColor300;
    case AttendanceStatus.today:
      return AppColors.greyColor900;
    case null:
      return Colors.transparent;
  }
}

Color _statusBgColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return AppColors.greenColor5005;
    case AttendanceStatus.late:
      return AppColors.warningColor1002;
    case AttendanceStatus.absent:
      return AppColors.errorColor2003;
    case AttendanceStatus.earlyLeave:
      return AppColors.blueColor5055;
    case AttendanceStatus.dayOff:
      return AppColors.greyColor25;
    case AttendanceStatus.today:
      return AppColors.greyColor25;
  }
}

String _statusLabel(BuildContext context, AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return context.tr('attendance.present');
    case AttendanceStatus.late:
      return context.tr('attendance.late');
    case AttendanceStatus.absent:
      return context.tr('attendance.absent');
    case AttendanceStatus.earlyLeave:
      return context.tr('attendance.earlyLeave');
    case AttendanceStatus.dayOff:
      return context.tr('attendance.dayOff');
    case AttendanceStatus.today:
      return context.tr('attendance.today');
  }
}

String _formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final restMinutes = minutes % 60;
  return '${hours}h ${restMinutes}m';
}
