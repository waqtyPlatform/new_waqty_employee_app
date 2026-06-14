import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class BonusHowItWorksCardWidget extends StatelessWidget {
  const BonusHowItWorksCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'bonusHowPunctuality',
      'bonusHowReviews',
      'bonusHowTarget',
      'bonusHowCalculated',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.howBonusesWork'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                context.tr('myEarning.$item'),
                style: TextStyles.font12greyColorA3W400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
