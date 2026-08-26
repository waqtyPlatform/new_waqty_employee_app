import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerLoadingWidget extends StatelessWidget {
  const HomeShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.whiteColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HomeTopSkeletonSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              child: Shimmer.fromColors(
                baseColor: AppColors.greyColor100,
                highlightColor: AppColors.greyColorFA,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 150.w, height: 18.h),
                    verticalSpace(14),
                    Row(
                      children: List.generate(
                        4,
                        (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: index == 0 ? 0 : 4.w,
                              end: index == 3 ? 0 : 4.w,
                            ),
                            child: const _SkeletonCard(height: 96),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(16),
                    const _SkeletonCard(height: 92),
                    verticalSpace(18),
                    _SkeletonBox(width: 150.w, height: 18.h),
                    verticalSpace(12),
                    const _SkeletonCard(height: 72),
                    verticalSpace(18),
                    _SkeletonBox(width: 110.w, height: 18.h),
                    verticalSpace(12),
                    const _SkeletonCard(height: 94),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTopSkeletonSection extends StatelessWidget {
  const _HomeTopSkeletonSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 18.h),
      color: AppColors.greyColor900,
      child: Shimmer.fromColors(
        baseColor: AppColors.greyColor700,
        highlightColor: AppColors.greyColor500,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SkeletonBox(width: 44.r, height: 44.r, radius: 100),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _SkeletonBox(width: 98.w, height: 16.h),
                      verticalSpace(8),
                      _SkeletonBox(width: 52.w, height: 12.h),
                    ],
                  ),
                  horizontalSpace(10),
                  _SkeletonBox(width: 44.r, height: 44.r, radius: 100),
                ],
              ),
              verticalSpace(18),
              const _SkeletonCard(height: 44, radius: 100),
              verticalSpace(20),
              _SkeletonBox(width: 110.w, height: 12.h),
              verticalSpace(8),
              _SkeletonBox(width: 180.w, height: 28.h),
              verticalSpace(12),
              _SkeletonBox(width: 170.w, height: 36.h, radius: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double height;
  final double radius;

  const _SkeletonCard({required this.height, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return _SkeletonBox(
      width: double.infinity,
      height: height.h,
      radius: radius,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

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
