import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_clock_action_dialog_widget.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_state.dart';
import 'package:new_waqty_employee_app/features/main_navigation/cubit/main_navigation_cubit.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/home_header_widget.dart';
import 'widgets/home_search_widget.dart';
import 'widgets/home_snapshot_widget.dart';
import 'widgets/home_earnings_widget.dart';
import 'widgets/home_upcoming_appointments_widget.dart';
import 'widgets/home_latest_review_widget.dart';
import 'widgets/home_shimmer_loading_widget.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final summary = cubit.summary;
        final isInitialLoading =
            summary == null &&
            (state is InitialState ||
                state is OnHomeLoadingState ||
                cubit.isHomeLoading ||
                cubit.isSnapshotLoading ||
                cubit.isEarningsLoading ||
                cubit.isAppointmentsLoading ||
                cubit.isLatestReviewLoading);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isInitialLoading
              ? const SystemUiOverlayStyle(
                  statusBarColor: AppColors.whiteColor,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                )
              : const SystemUiOverlayStyle(
                  statusBarColor: AppColors.greyColor900,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
          child: Scaffold(
            backgroundColor: isInitialLoading
                ? AppColors.whiteColor
                : AppColors.greyColor900,
            body: SafeArea(
              bottom: false,
              child: _buildContent(
                context,
                state,
                summary,
                isInitialLoading: isInitialLoading,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    HomeState state,
    HomeSummaryModel? summary,
    {
    required bool isInitialLoading,
  }) {
    if (isInitialLoading) {
      return const HomeShimmerLoadingWidget();
    }

    if (summary == null) {
      return _ErrorView(
        message: state is OnHomeErrorState
            ? state.message
            : context.tr('common.errorMessage'),
        onRetry: () {
          final cubit = HomeCubit.get(context);
          cubit.getHomeSummary();
          cubit.getHomeSections();
        },
      );
    }

    return ColoredBox(
      color: AppColors.whiteColor,
      child: RefreshIndicator(
        color: AppColors.greenColor500,
        onRefresh: () async {
          final cubit = HomeCubit.get(context);
          await Future.wait([cubit.getHomeSummary(), cubit.getHomeSections()]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeTopSection(summary: summary),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HomeSnapshotSection(),
                    verticalSpace(16),
                    const _HomeEarningsSection(),
                    verticalSpace(16),
                    const _HomeAppointmentsSection(),
                    verticalSpace(16),
                    const _HomeLatestReviewSection(),
                    verticalSpace(24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTopSection extends StatelessWidget {
  final HomeSummaryModel summary;

  const _HomeTopSection({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 18.h),
      decoration: const BoxDecoration(color: AppColors.greyColor900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeaderWidget(
            employeeName: summary.employeeName,
            employeeAvatarUrl: summary.employeeAvatarUrl,
            branchName: summary.branchName,
            onAvatarTap: () => MainNavigationCubit.get(context).changeTab(4),
            onNotificationTap: () =>
                Navigator.pushNamed(context, Routes.notificationsScreen),
          ),
          const HomeSearchWidget(),
          verticalSpace(18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _HomeGreetingWidget(summary: summary),
          ),
        ],
      ),
    );
  }
}

class _HomeGreetingWidget extends StatelessWidget {
  final HomeSummaryModel summary;

  const _HomeGreetingWidget({required this.summary});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(summary.date) ?? DateTime.now();
    final dateLabel = AppDateFormat.dayMonth(context, date);
    final firstName = _firstName(summary.employeeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(dateLabel, style: TextStyles.font12greyColor3003Weight500),
        verticalSpace(6),
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: TextStyles.font26whiteColorWeight600,
            children: [
              TextSpan(text: '${context.tr(_greetingKey())}, '),
              TextSpan(
                text: firstName,
                style: TextStyles.font26whiteColorWeight600.copyWith(
                  color: AppColors.greenColor500,
                ),
              ),
            ],
          ),
        ),
        verticalSpace(12),
        _ClockStatePill(summary: summary),
      ],
    );
  }

  String _greetingKey() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'home.goodMorning';
    if (hour < 17) return 'home.goodAfternoon';
    return 'home.goodEvening';
  }

  String _firstName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty || parts.first.isEmpty ? '' : parts.first;
  }
}

class _ClockStatePill extends StatelessWidget {
  final HomeSummaryModel summary;

  const _ClockStatePill({required this.summary});

  @override
  Widget build(BuildContext context) {
    final time = summary.clockedInAt == null
        ? ''
        : AppDateFormat.time(context, summary.clockedInAt!);
    final statusText = summary.clockedIn && time.isNotEmpty
        ? context.tr('home.clockedInSince', namedArgs: {'time': time})
        : context.tr(
            summary.clockedIn ? 'home.clockedIn' : 'home.notClockedIn',
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openProfileClockDialog(context),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(10.w, 6.h, 6.w, 6.h),
        decoration: BoxDecoration(
          color: AppColors.greyColor800.withValues(alpha: .65),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: AppColors.greyColor700, width: 1.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: summary.clockedIn
                    ? AppColors.greenColor500
                    : AppColors.whiteColor,
              ),
            ),
            horizontalSpace(8),
            Flexible(
              child: Text(
                statusText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font12greyColor3003Weight500.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            horizontalSpace(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.greenColor500,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                context.tr(summary.clockedIn ? 'home.active' : 'home.clockIn'),
                style: TextStyles.font12whiteColorWeight600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openProfileClockDialog(BuildContext context) async {
    final homeCubit = HomeCubit.get(context);
    final profileCubit = ProfileCubit(getIt());

    try {
      await profileCubit.init();
      if (!context.mounted) return;
      await ProfileClockActionDialogWidget.show(
        context,
        isClockedIn: profileCubit.isClockedIn,
        isOnBreak: profileCubit.isOnBreak,
        cubit: profileCubit,
      );
      if (context.mounted) {
        homeCubit.getHomeSummary();
        homeCubit.getHomeSections();
      }
    } finally {
      await profileCubit.close();
    }
  }
}

class _HomeSnapshotSection extends StatelessWidget {
  const _HomeSnapshotSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeSnapshotLoadingState ||
          current is HomeSnapshotSuccessState ||
          current is HomeSnapshotErrorState,
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        if (cubit.isSnapshotLoading && cubit.snapshot == null) {
          return const _SectionLoadingCard();
        }
        if (cubit.snapshot == null) {
          return _SectionErrorCard(
            message: cubit.snapshotError,
            onRetry: cubit.getTodaySnapshot,
          );
        }
        final snapshot = cubit.snapshot!;
        return HomeSnapshotWidget(
          booked: snapshot.booked.toString(),
          done: snapshot.done.toString(),
          left: snapshot.left.toString(),
          rating: snapshot.ratingLabel,
        );
      },
    );
  }
}

class _HomeEarningsSection extends StatelessWidget {
  const _HomeEarningsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeEarningsLoadingState ||
          current is HomeEarningsSuccessState ||
          current is HomeEarningsErrorState,
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        if (cubit.isEarningsLoading && cubit.earnings == null) {
          return const _SectionLoadingCard();
        }
        if (cubit.earnings == null) {
          return _SectionErrorCard(
            message: cubit.earningsError,
            onRetry: cubit.getTodayEarnings,
          );
        }
        return HomeEarningsWidget(
          amount: cubit.earnings!.displayAmount,
          isPayrollProcessed: cubit.earnings!.payrollProcessed,
        );
      },
    );
  }
}

class _HomeAppointmentsSection extends StatelessWidget {
  const _HomeAppointmentsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeAppointmentsLoadingState ||
          current is HomeAppointmentsSuccessState ||
          current is HomeAppointmentsErrorState,
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        if (cubit.isAppointmentsLoading && cubit.appointments.isEmpty) {
          return const _SectionLoadingCard();
        }
        if (cubit.appointmentsError.isNotEmpty && cubit.appointments.isEmpty) {
          return _SectionErrorCard(
            message: cubit.appointmentsError,
            onRetry: cubit.getUpcomingAppointments,
          );
        }
        return HomeUpcomingAppointmentsWidget(appointments: cubit.appointments);
      },
    );
  }
}

class _HomeLatestReviewSection extends StatelessWidget {
  const _HomeLatestReviewSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeLatestReviewLoadingState ||
          current is HomeLatestReviewSuccessState ||
          current is HomeLatestReviewErrorState,
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        if (cubit.isLatestReviewLoading && cubit.latestReview == null) {
          return const _SectionLoadingCard();
        }
        if (cubit.latestReviewError.isNotEmpty && cubit.latestReview == null) {
          return _SectionErrorCard(
            message: cubit.latestReviewError,
            onRetry: cubit.getLatestReview,
          );
        }
        return HomeLatestReviewWidget(review: cubit.latestReview);
      },
    );
  }
}

class _SectionLoadingCard extends StatelessWidget {
  const _SectionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100,
      highlightColor: AppColors.greyColorFA,
      child: Container(
        height: 96.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.greyColor1001.withValues(alpha: .2),
            width: .8,
          ),
        ),
      ),
    );
  }
}

class _SectionErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SectionErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
      ),
      child: Column(
        children: [
          Text(
            message.isEmpty ? context.tr('common.errorMessage') : message,
            textAlign: TextAlign.center,
            style: TextStyles.font12greyColor500W400,
          ),
          verticalSpace(8),
          TextButton(
            onPressed: onRetry,
            child: Text(
              context.tr('common.retry'),
              style: TextStyles.font14greenColor500Weight600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W400,
            ),
            verticalSpace(12),
            TextButton(
              onPressed: onRetry,
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
