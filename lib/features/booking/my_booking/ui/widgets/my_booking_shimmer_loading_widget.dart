import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:shimmer/shimmer.dart';

class MyBookingShimmerLoadingWidget extends StatelessWidget {
  const MyBookingShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100,
      highlightColor: AppColors.greyColorFA,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        itemBuilder: (_, __) => const MyBookingCardSkeletonWidget(),
        separatorBuilder: (_, __) => verticalSpace(12),
        itemCount: 4,
      ),
    );
  }
}

class MyBookingPaginationSkeletonWidget extends StatelessWidget {
  const MyBookingPaginationSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100,
      highlightColor: AppColors.greyColorFA,
      child: const MyBookingCardSkeletonWidget(),
    );
  }
}

class MyBookingCardSkeletonWidget extends StatelessWidget {
  const MyBookingCardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.greyColor50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 28.w, height: 24.h, radius: 8),
              horizontalSpace(8),
              _SkeletonBox(width: 64.w, height: 14.h, radius: 6),
              const Spacer(),
              _SkeletonBox(width: 54.w, height: 20.h, radius: 16),
            ],
          ),
          verticalSpace(12),
          Divider(color: AppColors.greyColor50, thickness: 1),
          verticalSpace(16),
          Row(
            children: [
              _SkeletonBox(width: 64.w, height: 64.h, radius: 8),
              horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 110.w, height: 16.h, radius: 6),
                    verticalSpace(8),
                    _SkeletonBox(width: double.infinity, height: 12.h),
                    verticalSpace(6),
                    _SkeletonBox(width: 120.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(child: _SkeletonBox(height: 38.h, radius: 8)),
              horizontalSpace(10),
              Expanded(child: _SkeletonBox(height: 38.h, radius: 8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}
