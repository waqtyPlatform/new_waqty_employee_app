import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:shimmer/shimmer.dart';

class MoneyScreenLoadingWidget extends StatelessWidget {
  final List<double> heights;

  const MoneyScreenLoadingWidget({
    super.key,
    this.heights = const [48, 36, 168, 64, 360],
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor100,
      highlightColor: AppColors.greyColorFA,
      child: Column(
        children: [
          for (var index = 0; index < heights.length; index++) ...[
            _MoneySkeletonBox(height: heights[index]),
            if (index != heights.length - 1) verticalSpace(12),
          ],
        ],
      ),
    );
  }
}

class _MoneySkeletonBox extends StatelessWidget {
  final double height;

  const _MoneySkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height.h,
      decoration: myEarningCardDecoration(),
    );
  }
}
