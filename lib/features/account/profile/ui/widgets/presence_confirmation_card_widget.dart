import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/location_service.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';

class PresenceConfirmationCardWidget extends StatelessWidget {
  const PresenceConfirmationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          current is CheckCurrentAttendanceLoadingState ||
          current is CheckCurrentAttendanceSuccessState ||
          current is CheckCurrentAttendanceErrorState ||
          current is CheckCurrentAttendanceCatchErrorState ||
          current is PresenceConfirmationLoadingState ||
          current is PresenceConfirmationSuccessState ||
          current is PresenceConfirmationErrorState ||
          current is PresenceConfirmationCatchErrorState,
      builder: (context, state) {
        final cubit = ProfileCubit.get(context);
        final session = cubit.currentAttendanceSession;
        final confirmation = session?.presenceConfirmation;
        if (session?.hasWaitingPresenceConfirmation != true ||
            confirmation == null) {
          return const SizedBox.shrink();
        }

        final deadline = confirmation.deadlineDateTime?.toLocal();
        final expectedEnd = confirmation.expectedEndDateTime?.toLocal();

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.greenColor500.withValues(alpha: .06),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.greenColor500.withValues(alpha: .22),
              width: 1.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor500.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.greenColor500,
                      size: 20.r,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('presenceConfirmation.title'),
                          style: TextStyles.font14greyColor900Weight600,
                        ),
                        if (deadline != null) ...[
                          verticalSpace(2),
                          Text(
                            context.tr(
                              'presenceConfirmation.deadline',
                              namedArgs: {
                                'time': AppDateFormat.time(context, deadline),
                              },
                            ),
                            style: TextStyles.font12greyColorA3W400,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (expectedEnd != null) ...[
                verticalSpace(10),
                Text(
                  context.tr(
                    'presenceConfirmation.expectedEnd',
                    namedArgs: {
                      'time': AppDateFormat.dayMonthTime(context, expectedEnd),
                    },
                  ),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
              verticalSpace(12),
              Row(
                children: [
                  Expanded(
                    child: _PresenceButtonWidget(
                      title: context.tr('presenceConfirmation.no'),
                      isLoading: cubit.isPresenceConfirmationLoading,
                      color: AppColors.whiteColor,
                      textColor: AppColors.errorColor100,
                      borderColor: AppColors.errorColor100,
                      onTap: () =>
                          _submit(context, PresenceConfirmationResponse.no),
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: _PresenceButtonWidget(
                      title: context.tr('presenceConfirmation.yes'),
                      isLoading: cubit.isPresenceConfirmationLoading,
                      color: AppColors.greenColor500,
                      textColor: AppColors.whiteColor,
                      borderColor: AppColors.greenColor500,
                      onTap: () =>
                          _submit(context, PresenceConfirmationResponse.yes),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(
    BuildContext context,
    PresenceConfirmationResponse responseValue,
  ) async {
    final cubit = ProfileCubit.get(context);
    if (cubit.isPresenceConfirmationLoading) return;

    DateTime? expectedEndAt;
    if (responseValue == PresenceConfirmationResponse.yes) {
      expectedEndAt = await _pickExpectedEndAt(context, cubit);
      if (expectedEndAt == null) return;
    }

    final location = await _freshPosition();
    final position = location.position;
    if (location.messageKey != null && context.mounted) {
      AppConstant.toast(context.tr(location.messageKey!), false, context);
    }
    if (position == null || !context.mounted) return;

    final capturedAt = position.timestamp.toLocal();
    final succeeded = await cubit.respondPresenceConfirmation(
      responseValue: responseValue,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
      locationCapturedAt: _isoWithOffset(capturedAt),
      expectedEndAt: expectedEndAt == null
          ? null
          : _isoWithOffset(expectedEndAt.toLocal()),
    );

    if (!context.mounted) return;
    if (succeeded) {
      AppConstant.toast(
        context.tr('presenceConfirmation.responseSaved'),
        true,
        context,
      );
      return;
    }

    final message = cubit.presenceConfirmationErrorMessage.isNotEmpty
        ? cubit.presenceConfirmationErrorMessage
        : context.tr('presenceConfirmation.responseFailed');
    AppConstant.toast(message, false, context);
  }

  Future<DateTime?> _pickExpectedEndAt(
    BuildContext context,
    ProfileCubit cubit,
  ) async {
    final now = DateTime.now();
    final initial =
        cubit
            .currentAttendanceSession
            ?.presenceConfirmation
            ?.expectedEndDateTime
            ?.toLocal() ??
        now.add(const Duration(hours: 1));

    final date = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 2)),
    );
    if (date == null || !context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (!selected.isAfter(now)) {
      if (context.mounted) {
        AppConstant.toast(
          context.tr('presenceConfirmation.futureTimeRequired'),
          false,
          context,
        );
      }
      return null;
    }

    return selected;
  }

  Future<_FreshLocationResult> _freshPosition() async {
    final location = await YourLocation.getCurrentLocation(
      openAppSettingsOnDeniedForever: true,
      accuracy: LocationAccuracy.high,
    );
    final position = location.position;
    if (position == null) {
      return _FreshLocationResult.failure(
        location.failure == LocationFailure.serviceDisabled
            ? 'profile.locationServiceDisabled'
            : 'profile.locationPermissionRequired',
      );
    }

    if (position.latitude == 0 && position.longitude == 0) {
      return const _FreshLocationResult.failure(
        'presenceConfirmation.invalidLocation',
      );
    }

    if (position.accuracy > 100) {
      return const _FreshLocationResult.failure(
        'presenceConfirmation.lowAccuracy',
      );
    }

    final age = DateTime.now().difference(position.timestamp.toLocal());
    if (age > const Duration(minutes: 2)) {
      return const _FreshLocationResult.failure(
        'presenceConfirmation.staleLocation',
      );
    }

    return _FreshLocationResult.success(position);
  }

  String _isoWithOffset(DateTime value) {
    final offset = value.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final absoluteOffset = offset.abs();
    return '${_four(value.year)}-${_two(value.month)}-${_two(value.day)}'
        'T${_two(value.hour)}:${_two(value.minute)}:${_two(value.second)}'
        '$sign${_two(absoluteOffset.inHours)}:'
        '${_two(absoluteOffset.inMinutes.remainder(60))}';
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  String _four(int value) => value.toString().padLeft(4, '0');
}

class _FreshLocationResult {
  final Position? position;
  final String? messageKey;

  const _FreshLocationResult.success(this.position) : messageKey = null;

  const _FreshLocationResult.failure(this.messageKey) : position = null;
}

class _PresenceButtonWidget extends StatelessWidget {
  final String title;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _PresenceButtonWidget({
    required this.title,
    required this.isLoading,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading ? color.withValues(alpha: .65) : color,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: textColor,
                ),
              )
            : Text(
                title,
                style: TextStyles.font14greenColor500W500.copyWith(
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
