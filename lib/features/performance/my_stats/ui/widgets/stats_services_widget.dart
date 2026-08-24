import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';

class StatsServicesWidget extends StatelessWidget {
  final List<MyStatsServiceModel> services;

  const StatsServicesWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .05),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myStats.services'),
            style: TextStyles.font14greyColor900Weight500,
          ),
          verticalSpace(12),
          if (services.isEmpty)
            Text(
              context.tr('myStats.noServices'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              separatorBuilder: (context, index) => verticalSpace(16),
              itemBuilder: (context, index) {
                return _buildServiceItem(context, services[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, MyStatsServiceModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.serviceName.isEmpty ? '-' : item.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                  verticalSpace(2),
                  Text(
                    context.tr(
                      'myStats.completedServiceCount',
                      namedArgs: {'count': '${item.completedItemsCount}'},
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            horizontalSpace(12),
            Text(item.valueLabel, style: TextStyles.font12greyColorA3W400),
          ],
        ),
        verticalSpace(8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.greyColorFA.withValues(
                      alpha: .5,
                    ), // Very faint grey
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Container(
                  height: 6.h,
                  width:
                      constraints.maxWidth *
                      (item.sharePercentage.clamp(0, 100) / 100),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor500, // Standard green for bars
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
