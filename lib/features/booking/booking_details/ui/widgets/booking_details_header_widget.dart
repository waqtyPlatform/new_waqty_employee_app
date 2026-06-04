import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BookingDetailsHeaderWidget extends StatelessWidget {
  const BookingDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48.r,
          width: 48.r,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.greyColor50),
          ),
          child: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.arrow_back, color: AppColors.greyColor900),
          ),
        ),
        const Spacer(flex: 1),
        Text(
          context.tr('bookingDetails.title'),
          style: TextStyles.font18greyColor900Weight600,
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
