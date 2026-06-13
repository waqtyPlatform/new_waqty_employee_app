import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class AppPinHeaderWidget extends StatelessWidget {
  final String title;
  final bool canPop;

  const AppPinHeaderWidget({
    super.key,
    required this.title,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (canPop)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.greyColorFA,
                      width: 1.w,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 22.r,
                    color: AppColors.greyColor900,
                  ),
                ),
              ),
            ),
          Text(title, style: TextStyles.font18greyColor900Weight600),
        ],
      ),
    );
  }
}
