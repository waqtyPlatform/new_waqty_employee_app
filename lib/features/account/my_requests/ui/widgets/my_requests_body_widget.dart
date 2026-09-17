import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/logic/my_requests_cubit.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/logic/my_requests_state.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class MyRequestsBodyWidget extends StatelessWidget {
  const MyRequestsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyRequestsCubit, MyRequestsState>(
      buildWhen: (previous, current) =>
          current is MyRequestsTabChangedState ||
          current is MyRequestsSessionLoadingState ||
          current is MyRequestsSessionSuccessState ||
          current is MyRequestsSessionErrorState ||
          current is MyRequestsReasonChangedState ||
          current is MyRequestsSubmitLoadingState ||
          current is MyRequestsSubmitSuccessState ||
          current is MyRequestsSubmitErrorState,
      builder: (context, state) {
        final cubit = MyRequestsCubit.get(context);
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: _MyRequestsTabs(cubit: cubit),
            ),
            Expanded(
              child: cubit.selectedTab == MyRequestsTab.earlyDeparture
                  ? _EarlyDepartureView(state: state, cubit: cubit)
                  : const _LeaveUnavailableView(),
            ),
          ],
        );
      },
    );
  }
}

class _EarlyDepartureView extends StatelessWidget {
  final MyRequestsState state;
  final MyRequestsCubit cubit;

  const _EarlyDepartureView({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit.isSessionLoading && cubit.currentSession == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.greenColor500),
      );
    }

    if (state is MyRequestsSessionErrorState && cubit.currentSession == null) {
      return _ErrorView(
        message: (state as MyRequestsSessionErrorState).message,
      );
    }

    return RefreshIndicator(
      color: AppColors.greenColor500,
      onRefresh: cubit.getCurrentSession,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        children: [
          _CurrentSessionCard(session: cubit.currentSession),
          verticalSpace(12),
          _EarlyDepartureStatusCard(session: cubit.currentSession),
          verticalSpace(12),
          if (cubit.canSubmitEarlyDeparture)
            _ReasonCard(cubit: cubit)
          else
            _BlockedRequestCard(session: cubit.currentSession),
        ],
      ),
    );
  }
}

class _MyRequestsTabs extends StatelessWidget {
  final MyRequestsCubit cubit;

  const _MyRequestsTabs({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SwitchButton(
            title: context.tr('myRequests.earlyDeparture'),
            isSelected: cubit.selectedTab == MyRequestsTab.earlyDeparture,
            onTap: () => cubit.changeTab(MyRequestsTab.earlyDeparture),
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _SwitchButton(
            title: context.tr('myRequests.leaveRequest'),
            isSelected: cubit.selectedTab == MyRequestsTab.leave,
            onTap: () => cubit.changeTab(MyRequestsTab.leave),
          ),
        ),
      ],
    );
  }
}

class _CurrentSessionCard extends StatelessWidget {
  final AttendanceSessionModel? session;

  const _CurrentSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final clockInAt = session?.clockInAt == null
        ? null
        : DateTime.tryParse(session!.clockInAt!.trim())?.toLocal();
    return AccountSupportCardWidget(
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: session == null
                ? AppColors.greyColorFA
                : AppColors.greenColor500.withValues(alpha: .1),
            child: Icon(
              Icons.access_time,
              color: session == null
                  ? AppColors.greyColor300
                  : AppColors.greenColor500,
              size: 18.r,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session == null
                      ? context.tr('myRequests.noOpenSession')
                      : context.tr('myRequests.openSession'),
                  style: TextStyles.font14greyColor900Weight600,
                ),
                verticalSpace(4),
                Text(
                  clockInAt == null
                      ? context.tr('myRequests.noSessionHint')
                      : AppDateFormat.dayMonthTime(context, clockInAt),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EarlyDepartureStatusCard extends StatelessWidget {
  final AttendanceSessionModel? session;

  const _EarlyDepartureStatusCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final earlyDeparture = session?.earlyDeparture;
    final status = earlyDeparture?.status ?? '';
    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('myRequests.currentRequest'),
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              _StatusChip(status: status),
            ],
          ),
          verticalSpace(8),
          Text(
            _statusDescription(context, earlyDeparture),
            style: TextStyles.font12greyColor500W400.copyWith(height: 1.45),
          ),
          if ((earlyDeparture?.reviewReason ?? '').trim().isNotEmpty) ...[
            verticalSpace(8),
            Text(
              earlyDeparture!.reviewReason!.trim(),
              style: TextStyles.font12greyColor500W400.copyWith(
                color: AppColors.errorColor100,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  final MyRequestsCubit cubit;

  const _ReasonCard({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myRequests.reason'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          TextField(
            controller: cubit.reasonController,
            maxLines: 6,
            maxLength: 1000,
            onChanged: cubit.onReasonChanged,
            decoration: InputDecoration(
              hintText: context.tr('myRequests.reasonHint'),
              errorText: cubit.reasonError == null
                  ? null
                  : context.tr(cubit.reasonError!),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.greyColor1001),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.greyColor1001),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.greenColor500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedRequestCard extends StatelessWidget {
  final AttendanceSessionModel? session;

  const _BlockedRequestCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final earlyDeparture = session?.earlyDeparture;
    return AccountSupportCardWidget(
      child: Text(
        session == null
            ? context.tr('myRequests.noOpenSession')
            : _statusDescription(context, earlyDeparture),
        style: TextStyles.font12greyColor500W400.copyWith(height: 1.45),
      ),
    );
  }
}

class _LeaveUnavailableView extends StatelessWidget {
  const _LeaveUnavailableView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      children: [
        AccountSupportCardWidget(
          child: Column(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.greyColorFA,
                child: Icon(
                  Icons.event_busy_outlined,
                  color: AppColors.greyColor500,
                  size: 22.r,
                ),
              ),
              verticalSpace(10),
              Text(
                context.tr('myRequests.leaveUnavailableTitle'),
                style: TextStyles.font14greyColor900Weight600,
              ),
              verticalSpace(6),
              Text(
                context.tr('myRequests.leaveUnavailableMessage'),
                textAlign: TextAlign.center,
                style: TextStyles.font12greyColorA3W400.copyWith(height: 1.45),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isEmpty ? context.tr('common.errorMessage') : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(10),
            TextButton(
              onPressed: MyRequestsCubit.get(context).getCurrentSession,
              child: Text(
                context.tr('common.retry'),
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SwitchButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor500 : AppColors.greyColorFA,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? AppColors.greenColor500 : AppColors.greyColorF5,
            width: .8.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyles.font12greyColor900Weight600.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.greyColor500,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        _statusLabel(context, status),
        style: TextStyles.font12greyColor900Weight600.copyWith(color: color),
      ),
    );
  }
}

String _statusLabel(BuildContext context, String status) {
  return switch (status) {
    'pending' => context.tr('myRequests.statusPending'),
    'approved' => context.tr('myRequests.statusApproved'),
    'rejected' => context.tr('myRequests.statusRejected'),
    'expired' => context.tr('myRequests.statusExpired'),
    _ => context.tr('myRequests.noRequest'),
  };
}

String _statusDescription(
  BuildContext context,
  EarlyDepartureModel? earlyDeparture,
) {
  if (earlyDeparture == null) return context.tr('myRequests.noCurrentRequest');
  if (earlyDeparture.isPending) return context.tr('myRequests.pendingHint');
  if (earlyDeparture.isApproved) return context.tr('myRequests.approvedHint');
  if (earlyDeparture.isRejected) return context.tr('myRequests.rejectedHint');
  if (earlyDeparture.isExpired) return context.tr('myRequests.expiredHint');
  return context.tr('myRequests.noCurrentRequest');
}

Color _statusColor(String status) {
  return switch (status) {
    'pending' => AppColors.warningColor1001,
    'approved' => AppColors.greenColor500,
    'rejected' => AppColors.errorColor100,
    'expired' => AppColors.greyColor500,
    _ => AppColors.greyColor500,
  };
}
