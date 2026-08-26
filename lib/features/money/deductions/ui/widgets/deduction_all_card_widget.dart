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

class DeductionAllCardWidget extends StatelessWidget {
  const DeductionAllCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deductions = context.watch<DeductionsCubit>().deductions;
    final items = deductions?.items ?? const [];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.allDeductions'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          if (items.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font12greyColorA3W400,
            )
          else ...[
            ...List.generate(
              items.length,
              (index) => _DeductionEntryRowWidget(
                item: items[index],
                showDivider: index != items.length - 1,
              ),
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .35)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('myEarning.total'),
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                ),
                Text(
                  formatMoney(
                    deductions?.total ?? 0,
                    deductions?.currency ?? '',
                    minus: true,
                  ),
                  style: TextStyles.font14errorColor2002W500,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DeductionEntryRowWidget extends StatelessWidget {
  final MoneyLineItem item;
  final bool showDivider;

  const _DeductionEntryRowWidget({required this.item, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .12),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  color: AppColors.errorColor2003,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.errorColor2002,
                  size: 16.r,
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
                        style: TextStyles.font12greyColorA3W400,
                      ),
                    ],
                  ],
                ),
              ),
              horizontalSpace(8),
              Text(
                formatMoney(item.amount, item.currency, minus: true),
                style: TextStyles.font14errorColor2002W500,
              ),
              horizontalSpace(6),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.greyColor100,
                size: 18.r,
              ),
            ],
          ),
          if (item.source.isNotEmpty) ...[
            verticalSpace(10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.errorColor2003,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(item.source, style: TextStyles.font12greyColorA3W400),
            ),
          ],
        ],
      ),
    );
  }
}
