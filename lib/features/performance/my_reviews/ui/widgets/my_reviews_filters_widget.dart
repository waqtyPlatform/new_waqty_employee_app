import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class MyReviewsFiltersWidget extends StatelessWidget {
  final int? selectedRating;
  final ValueChanged<int?> onChanged;

  const MyReviewsFiltersWidget({
    super.key,
    required this.selectedRating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <int?>[null, 5, 4, 3, 2, 1];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((rating) {
          final isSelected = selectedRating == rating;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(rating),
              child: Container(
                height: 34.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.greenColor500
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.greenColor500
                        : AppColors.greyColor1001.withValues(alpha: .3),
                    width: .8,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.greyColor900.withValues(
                              alpha: .05,
                            ),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rating == null ? context.tr('myStats.all') : '$rating',
                      style: TextStyles.font14greenColor500Weight500.copyWith(
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.greenColor500,
                      ),
                    ),
                    if (rating != null) ...[
                      horizontalSpace(4),
                      Icon(
                        Icons.star,
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.greenColor500,
                        size: 12.r,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
