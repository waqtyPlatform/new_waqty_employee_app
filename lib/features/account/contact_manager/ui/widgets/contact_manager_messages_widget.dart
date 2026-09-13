import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/models/contact_manager_response_model.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class ContactManagerMessagesWidget extends StatelessWidget {
  const ContactManagerMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactManagerCubit, ContactManagerState>(
      buildWhen: (previous, current) =>
          current is ContactManagerMessagesLoadingState ||
          current is ContactManagerMessagesSuccessState ||
          current is ContactManagerMessagesErrorState ||
          current is ContactManagerMessagesPaginationLoadingState ||
          current is ContactManagerMessagesPaginationSuccessState,
      builder: (context, state) {
        final cubit = ContactManagerCubit.get(context);
        if (cubit.isMessagesLoading && cubit.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenColor500),
          );
        }

        if (state is ContactManagerMessagesErrorState &&
            cubit.messages.isEmpty) {
          return _MessagesErrorWidget(message: state.message);
        }

        if (cubit.messages.isEmpty) {
          return const _MessagesEmptyWidget();
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: cubit.refreshMessages,
          child: ListView.separated(
            controller: cubit.messagesScrollController,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              if (index == cubit.messages.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor500,
                    ),
                  ),
                );
              }
              return _MessageCard(message: cubit.messages[index]);
            },
            separatorBuilder: (_, _) => verticalSpace(10),
            itemCount:
                cubit.messages.length + (cubit.isPaginationLoading ? 1 : 0),
          ),
        );
      },
    );
  }
}

class _MessageCard extends StatelessWidget {
  final ContactManagerMessageModel message;

  const _MessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final createdAt = AppDateFormat.parseBackendDateTime(message.createdAt);
    final resolvedAt = message.resolvedAt == null
        ? null
        : AppDateFormat.parseBackendDateTime(message.resolvedAt!);

    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  message.subject,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              horizontalSpace(8),
              _StatusChip(status: message.status),
            ],
          ),
          verticalSpace(8),
          Text(
            message.message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font12greyColor500W400.copyWith(height: 1.45),
          ),
          verticalSpace(10),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _MetaChip(
                label:
                    '${context.tr('contactManager.priority')}: ${_priorityLabel(context, message.priority)}',
                color: _priorityColor(message.priority),
              ),
              if (createdAt != null)
                _MetaChip(
                  label: AppDateFormat.dayMonthTime(context, createdAt),
                  color: AppColors.greyColor500,
                ),
              if (resolvedAt != null)
                _MetaChip(
                  label:
                      '${context.tr('contactManager.resolvedAt')}: ${AppDateFormat.dayMonthTime(context, resolvedAt)}',
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

class _MessagesEmptyWidget extends StatelessWidget {
  const _MessagesEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.greenColor500,
      onRefresh: ContactManagerCubit.get(context).refreshMessages,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 220.h),
          Center(
            child: Text(
              context.tr('contactManager.noRequests'),
              style: TextStyles.font14greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesErrorWidget extends StatelessWidget {
  final String message;

  const _MessagesErrorWidget({required this.message});

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
                  ? context.tr('contactManager.requestsLoadFailed')
                  : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(10),
            TextButton(
              onPressed: () =>
                  ContactManagerCubit.get(context).getMessages(refresh: true),
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

String _statusLabel(BuildContext context, String status) {
  return switch (status) {
    'open' => context.tr('contactManager.statusOpen'),
    'in_progress' => context.tr('contactManager.statusInProgress'),
    'resolved' => context.tr('contactManager.statusResolved'),
    'closed' => context.tr('contactManager.statusClosed'),
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

String _priorityLabel(BuildContext context, String priority) {
  return switch (priority) {
    'urgent' => context.tr('contactManager.urgent'),
    'normal' => context.tr('contactManager.normal'),
    _ => priority,
  };
}

Color _priorityColor(String priority) {
  return priority == 'urgent'
      ? AppColors.errorColor2002
      : AppColors.greenColor500;
}
