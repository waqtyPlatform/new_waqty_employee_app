import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/search_widget.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: SearchWidget(
        hintText: 'Search for client, appointment..',
        hintStyle: TextStyles.font14greyColor500W500,
        textStyle: TextStyles.font14whiteColorWeight500,
        backgroundColor: AppColors.greyColor800,
        keyboardType: TextInputType.text,
        cursorColor: AppColors.whiteColor,
        onchange: (value) {},
        validator: (value) {},
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.greyColor3003,
          size: 24.r,
        ),
        suffixIcon: Icon(
          Icons.tune,
          color: AppColors.greyColor3003,
          size: 20.r,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor700, width: 1.3),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor700, width: 1.3),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
