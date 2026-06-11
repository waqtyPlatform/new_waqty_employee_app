import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class HelpFaqSectionWidget extends StatelessWidget {
  final String titleKey;
  final List<HelpFaqItemData> questions;
  final ValueChanged<String> onQuestionTap;

  const HelpFaqSectionWidget({
    super.key,
    required this.titleKey,
    required this.questions,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            context.tr(titleKey),
            style: TextStyles.font10greyColorA3W600,
          ),
        ),
        verticalSpace(8),
        AccountSupportCardWidget(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(questions.length, (index) {
              return HelpFaqItemWidget(
                item: questions[index],
                showDivider: index != questions.length - 1,
                onTap: () => onQuestionTap(questions[index].uuid),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class HelpFaqItemWidget extends StatelessWidget {
  final HelpFaqItemData item;
  final bool showDivider;
  final VoidCallback onTap;

  const HelpFaqItemWidget({
    super.key,
    required this.item,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 53.h,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                  ),
                  Icon(
                    item.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.greyColorE5,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (item.isExpanded)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
            color: AppColors.greyColorFA,
            child: Text(
              item.answer,
              style: TextStyles.font12greyColorA3W400.copyWith(height: 1.35),
            ),
          ),
        if (showDivider && !item.isExpanded)
          const Divider(height: 1, color: AppColors.greyColorF5),
      ],
    );
  }
}

class HelpFaqItemData {
  final String uuid;
  final String question;
  final String answer;
  final bool isExpanded;

  const HelpFaqItemData({
    required this.uuid,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
