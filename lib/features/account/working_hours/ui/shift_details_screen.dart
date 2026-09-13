import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/shift_details_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/shift_details_state.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_duration_formatter.dart';

class ShiftDetailsScreen extends StatelessWidget {
  const ShiftDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AccountSupportHeaderWidget(
              titleKey: 'workingHours.shiftDetails',
            ),
            Expanded(
              child: BlocBuilder<ShiftDetailsCubit, ShiftDetailsState>(
                builder: (context, state) {
                  final cubit = ShiftDetailsCubit.get(context);
                  if (state is ShiftDetailsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ShiftDetailsErrorState || cubit.shift == null) {
                    return _ShiftDetailsErrorWidget(
                      message: state is ShiftDetailsErrorState
                          ? state.message
                          : '',
                    );
                  }
                  return _ShiftDetailsContent(shift: cubit.shift!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShiftDetailsContent extends StatelessWidget {
  final WorkingHoursModel shift;

  const _ShiftDetailsContent({required this.shift});

  @override
  Widget build(BuildContext context) {
    final shiftTitle = shift.shift.title.trim().isEmpty
        ? context.tr('workingHours.shift')
        : shift.shift.title;
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
      physics: const BouncingScrollPhysics(),
      children: [
        AccountSupportCardWidget(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greenColor5005,
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      color: AppColors.greenColor500,
                      size: 22.r,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shiftTitle,
                          style: TextStyles.font16greyColor900Weight600,
                        ),
                        verticalSpace(3),
                        Text(
                          _formatDate(context, shift.shiftDate),
                          style: TextStyles.font12greyColorA3W400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpace(18),
              _InfoRow(
                label: context.tr('workingHours.shiftTime'),
                value:
                    '${_formatTime(context, shift.startTime)} - ${_formatTime(context, shift.endTime)}',
              ),
              _InfoRow(
                label: context.tr('workingHours.branch'),
                value: shift.branch.name,
              ),
              _InfoRow(
                label: context.tr('workingHours.status'),
                value: shift.status.trim().isNotEmpty
                    ? shift.status
                    : shift.isDayOff
                    ? context.tr('workingHours.dayOff')
                    : shift.active
                    ? context.tr('workingHours.active')
                    : context.tr('workingHours.inactive'),
              ),
              _InfoRow(
                label: context.tr('workingHours.netHours'),
                value: WorkingHoursDurationFormatter.format(shift.netMinutes),
              ),
              if (shift.breakMinutes > 0)
                _InfoRow(
                  label: context.tr('workingHours.breakTime'),
                  value: WorkingHoursDurationFormatter.format(
                    shift.breakMinutes,
                  ),
                ),
              if ((shift.shift.notes ?? '').trim().isNotEmpty)
                _InfoRow(
                  label: context.tr('bookingDetails.notes'),
                  value: shift.shift.notes!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: TextStyles.font12greyColorA3W400)),
          horizontalSpace(12),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyles.font14greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftDetailsErrorWidget extends StatelessWidget {
  final String message;

  const _ShiftDetailsErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.trim().isEmpty
                  ? context.tr('workingHours.shiftUnavailable')
                  : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(12),
            TextButton(
              onPressed: ShiftDetailsCubit.get(context).loadShift,
              child: Text(context.tr('common.retry')),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.mainNavigationScreen,
                (route) => false,
                arguments: {
                  'securityVerified': true,
                  'pinVerified': true,
                  'initialIndex': 1,
                },
              ),
              child: Text(context.tr('notificationInbox.viewSchedule')),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(BuildContext context, String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value.trim().isEmpty ? '--' : value;
  return AppDateFormat.fullDate(context, parsed);
}

String _formatTime(BuildContext context, String value) {
  if (value.trim().isEmpty) return '--';
  final dateTime = AppDateFormat.parseBackendDateTime(value);
  if (dateTime != null && value.contains(RegExp(r'[T ]'))) {
    return AppDateFormat.time(context, dateTime);
  }
  return AppDateFormat.timeOfDay(context, value);
}
