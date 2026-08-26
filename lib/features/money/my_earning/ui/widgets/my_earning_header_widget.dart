import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class MyEarningHeaderWidget extends StatelessWidget {
  const MyEarningHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Center(
        child: Text(
          context.tr('myEarning.title'),
          style: TextStyles.font18greyColor900Weight600,
        ),
      ),
    );
  }
}
