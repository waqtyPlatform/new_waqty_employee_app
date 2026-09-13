import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/models/report_bug_response_model.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_state.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class ReportBugListWidget extends StatelessWidget {
  const ReportBugListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBugCubit, ReportBugState>(
      buildWhen: (previous, current) =>
          current is ReportBugListLoadingState ||
          current is ReportBugListSuccessState ||
          current is ReportBugListErrorState ||
          current is ReportBugListPaginationLoadingState ||
          current is ReportBugListPaginationSuccessState,
      builder: (context, state) {
        final cubit = ReportBugCubit.get(context);
        if (cubit.isReportsLoading && cubit.reports.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenColor500),
          );
        }

        if (state is ReportBugListErrorState && cubit.reports.isEmpty) {
          return _ReportsErrorWidget(message: state.message);
        }

        if (cubit.reports.isEmpty) {
          return const _ReportsEmptyWidget();
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: cubit.refreshReports,
          child: ListView.separated(
            controller: cubit.reportsScrollController,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              if (index == cubit.reports.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor500,
                    ),
                  ),
                );
              }
              return _ReportCard(report: cubit.reports[index]);
            },
            separatorBuilder: (_, _) => verticalSpace(10),
            itemCount:
                cubit.reports.length + (cubit.isPaginationLoading ? 1 : 0),
          ),
        );
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ReportBugModel report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final createdAt = AppDateFormat.parseBackendDateTime(report.createdAt);
    final resolvedAt = report.resolvedAt == null
        ? null
        : AppDateFormat.parseBackendDateTime(report.resolvedAt!);
    final escalatedAt = report.escalatedAt == null
        ? null
        : AppDateFormat.parseBackendDateTime(report.escalatedAt!);

    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _categoryLabel(context, report.category),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              horizontalSpace(8),
              _StatusChip(status: report.status),
            ],
          ),
          verticalSpace(8),
          Text(
            report.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font12greyColor500W400.copyWith(height: 1.45),
          ),
          if ((report.stepsToReproduce ?? '').isNotEmpty) ...[
            verticalSpace(8),
            Text(
              report.stepsToReproduce!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColorA3W400,
            ),
          ],
          verticalSpace(10),
          Text(
            report.resolutionNote?.trim().isNotEmpty == true
                ? report.resolutionNote!.trim()
                : context.tr('reportBug.noResolutionYet'),
            style: TextStyles.font12greyColor500W400.copyWith(
              color: report.resolutionNote?.trim().isNotEmpty == true
                  ? AppColors.greyColor500
                  : AppColors.greyColorA3,
            ),
          ),
          verticalSpace(10),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              if ((report.appVersion ?? '').isNotEmpty)
                _MetaChip(
                  label:
                      '${context.tr('reportBug.appVersion')}: ${report.appVersion}',
                  color: AppColors.greyColor500,
                ),
              if (createdAt != null)
                _MetaChip(
                  label: AppDateFormat.dayMonthTime(context, createdAt),
                  color: AppColors.greyColor500,
                ),
              if (escalatedAt != null)
                _MetaChip(
                  label: context.tr('reportBug.escalatedToManagement'),
                  color: AppColors.warningColor1001,
                ),
              if (resolvedAt != null)
                _MetaChip(
                  label:
                      '${context.tr('reportBug.resolvedAt')}: ${AppDateFormat.dayMonthTime(context, resolvedAt)}',
                  color: AppColors.greenColor500,
                ),
            ],
          ),
        ],
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

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyles.font10greyColor3003Weight500.copyWith(color: color),
      ),
    );
  }
}

class _ReportsEmptyWidget extends StatelessWidget {
  const _ReportsEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.greenColor500,
      onRefresh: ReportBugCubit.get(context).refreshReports,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 220.h),
          Center(
            child: Text(
              context.tr('reportBug.noReports'),
              style: TextStyles.font14greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsErrorWidget extends StatelessWidget {
  final String message;

  const _ReportsErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isEmpty
                  ? context.tr('reportBug.reportsLoadFailed')
                  : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(10),
            TextButton(
              onPressed: () =>
                  ReportBugCubit.get(context).getReports(refresh: true),
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

String _categoryLabel(BuildContext context, String category) {
  return switch (category) {
    'appointments' => context.tr('reportBug.appointments'),
    'schedule' => context.tr('reportBug.schedule'),
    'earnings' => context.tr('reportBug.earnings'),
    'clock_in_out' || 'clockInOut' => context.tr('reportBug.clockInOut'),
    'notifications' => context.tr('reportBug.notifications'),
    'other' => context.tr('reportBug.other'),
    _ => category,
  };
}

String _statusLabel(BuildContext context, String status) {
  return switch (status) {
    'open' => context.tr('reportBug.statusOpen'),
    'in_progress' => context.tr('reportBug.statusInProgress'),
    'resolved' => context.tr('reportBug.statusResolved'),
    'closed' => context.tr('reportBug.statusClosed'),
    _ => status,
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'open' => AppColors.blueColor506,
    'in_progress' => AppColors.warningColor1001,
    'resolved' => AppColors.greenColor500,
    'closed' => AppColors.greyColor500,
    _ => AppColors.greyColor500,
  };
}
