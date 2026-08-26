import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DailyEarningServicesCardWidget extends StatelessWidget {
  const DailyEarningServicesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<DailyEarningDetailsCubit>().details;
    final services = details?.services ?? [];
    final fallbackCurrency = details?.currency ?? '';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.servicesPerformed'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          if (services.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...services.map(
              (service) => _DailyServiceItemWidget(
                service: service,
                fallbackCurrency: fallbackCurrency,
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyServiceItemWidget extends StatelessWidget {
  final DailyServiceMoneyItem service;
  final String fallbackCurrency;

  const _DailyServiceItemWidget({
    required this.service,
    required this.fallbackCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final currency = service.currency.isNotEmpty
        ? service.currency
        : fallbackCurrency;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyColor1001.withValues(alpha: .18),
            width: .8.w,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.greyColorFA.withValues(alpha: .65),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.content_cut,
              color: AppColors.greyColor500,
              size: 17.r,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight600,
                ),
                verticalSpace(2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        service.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font12greyColorA3W400,
                      ),
                    ),
                    horizontalSpace(6),
                    Container(
                      width: 2.r,
                      height: 2.r,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor200,
                        shape: BoxShape.circle,
                      ),
                    ),
                    horizontalSpace(6),
                    Text(
                      _formatTime(context, service.completedAt),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ],
                ),
                verticalSpace(2),
                Text(
                  '${context.tr('myEarning.commissionEarned')}: ${formatMoney(service.commissionAmount, currency)}',
                  style: TextStyles.font10greyColorA3w400.copyWith(
                    color: AppColors.greyColor300,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Text(
            formatMoney(service.serviceValueGenerated, currency),
            style: TextStyles.font14greenColor500Weight600,
          ),
        ],
      ),
    );
  }
}

String _formatTime(BuildContext context, String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return DateFormat('h:mm a', context.locale.toString()).format(date);
}
