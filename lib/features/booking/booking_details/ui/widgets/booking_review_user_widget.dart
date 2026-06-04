import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';

class BookingReviewUserWidget extends StatelessWidget {
  final String userName;
  const BookingReviewUserWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.03),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_border_outlined,
                color: AppColors.warningColor30033,
              ),
              horizontalSpace(8),
              Text(
                '${context.tr('bookingDetails.review')} $userName',
                style: TextStyles.font18greyColor900Weight600,
              ),
            ],
          ),
          verticalSpace(12),
          Text(
            context.tr('bookingDetails.reviewQuestion'),
            style: TextStyles.font12greyColor3003Weight400,
          ),
          verticalSpace(12),
          StarRating(
            rating: 3.5,
            allowHalfRating: true,
            filledIcon: Icons.star_outlined,
            halfFilledIcon: Icons.star_half,
            emptyIcon: Icons.star_border,
            color: AppColors.warningColor30033,
            borderColor: AppColors.warningColor30033,
            onRatingChanged: (rating) {},
          ),
          verticalSpace(12),
          AppTextFormField(
            hintText: context.tr('bookingDetails.reviewHint'),
            hintStyle: TextStyles.font14greyColor4002Weight400,
            maxLines: 8,
            contentPadding: EdgeInsets.symmetric(
              vertical: 11.h,
              horizontal: 12.w,
            ),
            textStyle: TextStyles.font14greyColor900Weight400,
            controller: TextEditingController(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyColor1001, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greenColor500, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorColor100, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorColor100, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return context.tr('bookingDetails.reviewHint');
              }
              return null;
            },
            backgroundColor: AppColors.whiteColor,
            onTap: () {},
            onTapOutside: () {},
            keyboardType: TextInputType.text,
          ),

          verticalSpace(16),
          ButtonWidget(
            isLoading: false,
            borderRadius: 12,
            buttonHeight: 52.h,
            buttonText: context.tr('bookingDetails.submitReview'),
            backGroundColor: AppColors.greenColor500,
            borderColor: AppColors.greenColor500,
            fourGroundColor: AppColors.whiteColor,
            textStyle: TextStyles.font16whiteColorWeight600,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
