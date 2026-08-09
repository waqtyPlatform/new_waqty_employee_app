import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';

class BookingReviewUserWidget extends StatefulWidget {
  final String userName;
  final BookingCustomerReviewModel? review;
  final bool isLoading;
  final void Function(int rating, String comment)? onSubmit;

  const BookingReviewUserWidget({
    super.key,
    required this.userName,
    this.review,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<BookingReviewUserWidget> createState() =>
      _BookingReviewUserWidgetState();
}

class _BookingReviewUserWidgetState extends State<BookingReviewUserWidget> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _setInitialReview();
  }

  @override
  void didUpdateWidget(covariant BookingReviewUserWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.review?.uuid != widget.review?.uuid ||
        oldWidget.review?.updatedAt != widget.review?.updatedAt) {
      _setInitialReview();
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _setInitialReview() {
    final review = widget.review;
    _rating = review?.rating.toDouble() ?? 0;
    _reviewController.text = review?.comment ?? '';
  }

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
                '${context.tr('bookingDetails.review')} ${widget.userName}',
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
            rating: _rating,
            allowHalfRating: false,
            filledIcon: Icons.star_outlined,
            halfFilledIcon: Icons.star_outlined,
            emptyIcon: Icons.star_border,
            color: AppColors.warningColor30033,
            borderColor: AppColors.warningColor30033,
            size: 24.r,
            onRatingChanged: widget.onSubmit == null
                ? null
                : (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
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
            controller: _reviewController,
            maxLength: 200,
            isEnable: widget.onSubmit != null,
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
              return null;
            },
            backgroundColor: AppColors.whiteColor,
            onTap: () {},
            onTapOutside: () {},
            keyboardType: TextInputType.text,
          ),

          if (widget.onSubmit != null) ...[
            verticalSpace(16),
            ButtonWidget(
              isLoading: widget.isLoading,
              borderRadius: 12,
              buttonHeight: 52.h,
              buttonText: context.tr('bookingDetails.submitReview'),
              backGroundColor: AppColors.greenColor500,
              borderColor: AppColors.greenColor500,
              fourGroundColor: AppColors.whiteColor,
              textStyle: TextStyles.font16whiteColorWeight600,
              onPressed: _submitReview,
            ),
          ],
        ],
      ),
    );
  }

  void _submitReview() {
    if (widget.isLoading) return;
    final rating = _rating.toInt();
    if (rating < 1 || rating > 5) {
      AppConstant.toast(
        context.tr('bookingDetails.ratingRequired'),
        false,
        context,
      );
      return;
    }
    widget.onSubmit?.call(rating, _reviewController.text.trim());
  }
}
