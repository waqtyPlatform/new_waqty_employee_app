import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class HelpContactCardWidget extends StatelessWidget {
  const HelpContactCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      child: Row(
        children: [
          Container(
            height: 32.r,
            width: 32.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greenColor5005,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: AppColors.greenColor500,
              size: 15.r,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('helpFaq.stillNeedHelp'),
                  style: TextStyles.font14greyColor900Weight600,
                ),
                verticalSpace(2),
                Text(
                  context.tr('helpFaq.messageManager'),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Text(
            context.tr('helpFaq.contact'),
            style: TextStyles.font12greenColor500W600,
          ),
        ],
      ),
    );
  }
}
