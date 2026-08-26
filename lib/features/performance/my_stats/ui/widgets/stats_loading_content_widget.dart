import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:shimmer/shimmer.dart';

class StatsLoadingContentWidget extends StatelessWidget {
  const StatsLoadingContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100,
      highlightColor: AppColors.greyColorFA,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: _StatsSkeletonBox(height: 102)),
                horizontalSpace(8),
                const Expanded(child: _StatsSkeletonBox(height: 102)),
              ],
            ),
            verticalSpace(8),
            Row(
              children: [
                const Expanded(child: _StatsSkeletonBox(height: 102)),
                horizontalSpace(8),
                const Expanded(child: _StatsSkeletonBox(height: 102)),
              ],
            ),
            verticalSpace(12),
            const _StatsSkeletonBox(height: 230),
            verticalSpace(12),
            const _StatsSkeletonBox(height: 194),
            verticalSpace(12),
            const _StatsSkeletonBox(height: 132),
            verticalSpace(12),
            const _StatsSkeletonBox(height: 118),
          ],
        ),
      ),
    );
  }
}

class _StatsSkeletonBox extends StatelessWidget {
  final double height;

  const _StatsSkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.greyColor100.withValues(alpha: .2),
          width: .8.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
