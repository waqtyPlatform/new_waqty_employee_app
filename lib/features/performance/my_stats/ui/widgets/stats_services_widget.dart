import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class StatsServicesWidget extends StatelessWidget {
  const StatsServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data matching the image
    final services = [
      _ServiceItemData(
        title: 'Haircut',
        count: 18,
        value: '2,700',
        percentage: 0.9,
      ),
      _ServiceItemData(
        title: 'Beard Trim',
        count: 12,
        value: '960',
        percentage: 0.55,
      ),
      _ServiceItemData(
        title: 'Hair Color',
        count: 4,
        value: '1,200',
        percentage: 0.05,
      ),
      _ServiceItemData(
        title: 'Keratin Treatment',
        count: 2,
        value: '1,000',
        percentage: 0.01,
      ),
      _ServiceItemData(
        title: 'Beard Design',
        count: 6,
        value: '720',
        percentage: 0.15,
      ),
    ];

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
          Text('Services', style: TextStyles.font14greyColor900Weight500),
          verticalSpace(12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (context, index) => verticalSpace(16),
            itemBuilder: (context, index) {
              return _buildServiceItem(services[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(_ServiceItemData item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.title, style: TextStyles.font14greyColor900Weight500),
            Text(
              '${item.count}x · EGP ${item.value}',
              style: TextStyles.font12greyColorA3W400,
            ),
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
                  width: constraints.maxWidth * item.percentage,
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

class _ServiceItemData {
  final String title;
  final int count;
  final String value;
  final double percentage;

  _ServiceItemData({
    required this.title,
    required this.count,
    required this.value,
    required this.percentage,
  });
}
