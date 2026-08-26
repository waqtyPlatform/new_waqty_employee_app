import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class BonusCategoriesCardWidget extends StatelessWidget {
  const BonusCategoriesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<BonusesCubit>().bonuses?.categories ?? const [];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.byCategory'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          if (categories.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...List.generate(
              categories.length,
              (index) => _BonusCategoryRowWidget(
                item: categories[index],
                showDivider: index != categories.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _BonusCategoryRowWidget extends StatelessWidget {
  final MoneyLineItem item;
  final bool showDivider;

  const _BonusCategoryRowWidget({required this.item, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .22),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.greenColor500.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.greenColor500,
              size: 15.r,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.isEmpty
                      ? context.tr('myEarning.bonus')
                      : item.title,
                  style: TextStyles.font14greyColor900Weight500,
                ),
                if (item.subtitle.isNotEmpty) ...[
                  verticalSpace(3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ],
            ),
          ),
          horizontalSpace(12),
          Text(
            formatMoney(item.amount, item.currency, plus: true),
            style: TextStyles.font14greenColor500Weight600,
          ),
        ],
      ),
    );
  }
}
