import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';

class MyServicesShimmerLoading extends StatelessWidget {
  const MyServicesShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100.withValues(alpha: 0.5),
      highlightColor: AppColors.greyColor50.withValues(alpha: 0.2),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: 12.r,
                //   backgroundColor: Colors.white,
                // ),
                // horizontalSpace(8),
                Expanded(
                  child: Container(
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),


              ],
            ),
          );
        },
        separatorBuilder: (context, index) =>
            Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
        itemCount: 10,
      ),
    );
  }
}
