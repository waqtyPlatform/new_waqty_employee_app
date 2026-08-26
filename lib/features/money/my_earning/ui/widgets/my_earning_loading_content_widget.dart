import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:shimmer/shimmer.dart';

class MyEarningLoadingContentWidget extends StatelessWidget {
  const MyEarningLoadingContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100,
      highlightColor: AppColors.greyColorFA,
      child: Column(
        children: [
          const _SkeletonBox(height: 148),
          verticalSpace(12),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: index == 0 ? 0 : 4.w,
                    end: index == 3 ? 0 : 4.w,
                  ),
                  child: const _SkeletonBox(height: 96),
                ),
              ),
            ),
          ),
          verticalSpace(12),
          const _SkeletonBox(height: 168),
          verticalSpace(12),
          const _SkeletonBox(height: 112),
          verticalSpace(12),
          const _SkeletonBox(height: 132),
          verticalSpace(12),
          const _SkeletonBox(height: 64),
          verticalSpace(12),
          const _SkeletonBox(height: 64),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;

  const _SkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height.h,
      decoration: myEarningCardDecoration(),
    );
  }
}
