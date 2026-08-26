import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DeductionCategoriesCardWidget extends StatelessWidget {
  const DeductionCategoriesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<DeductionsCubit>().deductions?.categories ?? const [];
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
              (index) => _DeductionCategoryRowWidget(
                item: categories[index],
                showDivider: index != categories.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _DeductionCategoryRowWidget extends StatelessWidget {
  final MoneyLineItem item;
  final bool showDivider;

  const _DeductionCategoryRowWidget({
    required this.item,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .15),
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
              color: AppColors.errorColor2003,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove_circle_outline,
              color: AppColors.errorColor2002,
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
                      ? context.tr('myEarning.deduction')
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
            formatMoney(item.amount, item.currency, minus: true),
            style: TextStyles.font14errorColor2002W500,
          ),
        ],
      ),
    );
  }
}
