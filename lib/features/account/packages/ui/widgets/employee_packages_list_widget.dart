import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/packages/logic/employee_packages_cubit.dart';
import 'package:new_waqty_employee_app/features/account/packages/logic/employee_packages_state.dart';
import 'package:new_waqty_employee_app/features/account/packages/ui/widgets/employee_package_card_widget.dart';

class EmployeePackagesListWidget extends StatelessWidget {
  const EmployeePackagesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeePackagesCubit, EmployeePackagesState>(
      buildWhen: (previous, current) =>
          current is EmployeePackagesLoadingState ||
          current is EmployeePackagesSuccessState ||
          current is EmployeePackagesErrorState ||
          current is EmployeePackagesPaginationLoadingState ||
          current is EmployeePackagesPaginationSuccessState,
      builder: (context, state) {
        final cubit = EmployeePackagesCubit.get(context);
        if (cubit.isLoading && cubit.packages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenColor500),
          );
        }

        if (state is EmployeePackagesErrorState && cubit.packages.isEmpty) {
          return _PackagesErrorWidget(message: state.message);
        }

        if (cubit.packages.isEmpty) {
          return const _PackagesEmptyWidget();
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: cubit.refreshPackages,
          child: ListView.separated(
            controller: cubit.scrollController,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              if (index == cubit.packages.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor500,
                    ),
                  ),
                );
              }
              final package = cubit.packages[index];
              return EmployeePackageCardWidget(
                package: package,
                onTap: () => context.pushNamed(
                  Routes.employeePackageDetailsScreen,
                  arguments: {'uuid': package.uuid},
                ),
              );
            },
            separatorBuilder: (_, _) => verticalSpace(10),
            itemCount:
                cubit.packages.length + (cubit.isPaginationLoading ? 1 : 0),
          ),
        );
      },
    );
  }
}

class _PackagesEmptyWidget extends StatelessWidget {
  const _PackagesEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.greenColor500,
      onRefresh: EmployeePackagesCubit.get(context).refreshPackages,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 220.h),
          Center(
            child: Text(
              context.tr('employeePackages.empty'),
              style: TextStyles.font14greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackagesErrorWidget extends StatelessWidget {
  final String message;

  const _PackagesErrorWidget({required this.message});

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
                  ? context.tr('employeePackages.loadFailed')
                  : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(10),
            TextButton(
              onPressed: () =>
                  EmployeePackagesCubit.get(context).getPackages(refresh: true),
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
