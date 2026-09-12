import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';
import 'package:new_waqty_employee_app/features/search/data/models/employee_search_models.dart';
import 'package:new_waqty_employee_app/features/search/logic/employee_search_cubit.dart';
import 'package:new_waqty_employee_app/features/search/logic/employee_search_state.dart';

class EmployeeSearchResultsWidget extends StatelessWidget {
  const EmployeeSearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeSearchCubit, EmployeeSearchState>(
      buildWhen: (previous, current) =>
          current is EmployeeSearchTypingState ||
          current is EmployeeSearchLoadingState ||
          current is EmployeeSearchSuccessState ||
          current is EmployeeSearchErrorState ||
          current is EmployeeCustomerAppointmentsLoadingState ||
          current is EmployeeCustomerAppointmentsSuccessState ||
          current is EmployeeCustomerAppointmentsErrorState,
      builder: (context, state) {
        final cubit = EmployeeSearchCubit.get(context);
        final query = cubit.searchController.text.trim();

        if (query.length < 2) {
          return _CenteredText(message: context.tr('employeeSearch.minChars'));
        }
        if (state is EmployeeSearchLoadingState && cubit.result == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenColor500),
          );
        }
        if (state is EmployeeSearchErrorState && cubit.result == null) {
          return _CenteredText(message: state.message);
        }

        final result = cubit.result;
        if (result == null || result.isEmpty) {
          return _CenteredText(message: context.tr('employeeSearch.noResults'));
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 20.h),
          children: [
            if (result.appointments.isNotEmpty) ...[
              _SectionTitle(title: context.tr('employeeSearch.appointments')),
              verticalSpace(8),
              ...result.appointments.map(
                (appointment) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _AppointmentResultCard(appointment: appointment),
                ),
              ),
              verticalSpace(8),
            ],
            if (result.customers.isNotEmpty) ...[
              _SectionTitle(title: context.tr('employeeSearch.customers')),
              verticalSpace(8),
              ...result.customers.map(
                (customer) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _CustomerResultCard(customer: customer),
                ),
              ),
            ],
            if (cubit.customerHistory != null ||
                state is EmployeeCustomerAppointmentsLoadingState ||
                state is EmployeeCustomerAppointmentsErrorState) ...[
              verticalSpace(10),
              _SectionTitle(title: context.tr('employeeSearch.history')),
              verticalSpace(8),
              _CustomerHistoryContent(state: state),
            ],
          ],
        );
      },
    );
  }
}

class _AppointmentResultCard extends StatelessWidget {
  final EmployeeSearchAppointmentModel appointment;

  const _AppointmentResultCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.bookingDetailsScreen,
        arguments: {'uuid': appointment.uuid},
      ),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _CustomerAvatar(customer: appointment.customer),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          appointment.customer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.font14greyColor900Weight600,
                        ),
                      ),
                      _StatusPill(status: appointment.status),
                    ],
                  ),
                  verticalSpace(5),
                  Text(
                    appointment.servicesLabel.isEmpty
                        ? '--'
                        : appointment.servicesLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColor500W500,
                  ),
                  verticalSpace(5),
                  Text(
                    _appointmentTime(context, appointment),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                  verticalSpace(5),
                  Row(
                    children: [
                      Text(
                        appointment.reference,
                        style: TextStyles.font12greyColorA3W400,
                      ),
                      const Spacer(),
                      Text(
                        appointment.totalLabel,
                        style: TextStyles.font12greyColor900Weight600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerResultCard extends StatelessWidget {
  final EmployeeSearchCustomerModel customer;

  const _CustomerResultCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => EmployeeSearchCubit.get(
        context,
      ).loadCustomerAppointments(customer.uuid),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _CustomerAvatar(customer: customer),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(5),
                  Text(
                    customer.phone.isEmpty ? customer.email : customer.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColor500W500,
                  ),
                  verticalSpace(5),
                  Text(
                    context.tr(
                      'employeeSearch.appointmentsCount',
                      namedArgs: {'count': '${customer.appointmentsCount}'},
                    ),
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.greyColorA3, size: 22.r),
          ],
        ),
      ),
    );
  }
}

class _CustomerHistoryContent extends StatelessWidget {
  final EmployeeSearchState state;

  const _CustomerHistoryContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = EmployeeSearchCubit.get(context);
    if (state is EmployeeCustomerAppointmentsLoadingState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.greenColor500),
        ),
      );
    }
    if (state is EmployeeCustomerAppointmentsErrorState) {
      final errorState = state as EmployeeCustomerAppointmentsErrorState;
      return _InlineMessage(message: errorState.message);
    }

    final history = cubit.customerHistory;
    if (history == null || history.appointments.isEmpty) {
      return _InlineMessage(message: context.tr('employeeSearch.noHistory'));
    }

    return Column(
      children: history.appointments
          .map(
            (appointment) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _AppointmentResultCard(appointment: appointment),
            ),
          )
          .toList(),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  final EmployeeSearchCustomerModel customer;

  const _CustomerAvatar({required this.customer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: customer.avatarUrl.isEmpty
          ? Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greenColor505,
              ),
              child: Text(
                customer.initials.isEmpty
                    ? _initial(customer.name)
                    : customer.initials,
                style: TextStyles.font14greenColor500Weight600,
              ),
            )
          : CachedNetworkImageWidget(
              imgUrl: customer.avatarUrl,
              radius: BorderRadius.circular(48.r),
            ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.blueColor5055,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        status,
        style: TextStyles.font10greyColorA3W600.copyWith(
          color: AppColors.blueColor506,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyles.font16greyColor900Weight600);
  }
}

class _CenteredText extends StatelessWidget {
  final String message;

  const _CenteredText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyles.font14greyColor500W400,
        ),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  final String message;

  const _InlineMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyles.font14greyColor500W400,
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.whiteColor,
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(color: AppColors.greyColor50),
    boxShadow: [
      BoxShadow(
        color: AppColors.greyColor900.withValues(alpha: .04),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

String _appointmentTime(
  BuildContext context,
  EmployeeSearchAppointmentModel appointment,
) {
  final start = appointment.scheduledStartAt;
  final end = appointment.scheduledEndAt;
  if (start == null) return appointment.bookingDate;
  final date = AppDateFormat.dayMonth(context, start);
  if (end == null) return '$date • ${AppDateFormat.time(context, start)}';
  return '$date • ${AppDateFormat.timeRange(context, start, end)}';
}

String _initial(String name) {
  final trimmed = name.trim();
  return trimmed.isEmpty ? '?' : String.fromCharCode(trimmed.runes.first);
}
