import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_service_model.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DailyEarningServicesCardWidget extends StatelessWidget {
  const DailyEarningServicesCardWidget({super.key});

  static const List<DailyEarningServiceModel> _services = [
    DailyEarningServiceModel(
      serviceName: 'Haircut',
      customerName: 'Nour',
      time: '11:00 AM',
      amount: 'EGP 150',
      extraction: 'EGP 15',
    ),
    DailyEarningServiceModel(
      serviceName: 'Beard Trim',
      customerName: 'Nour',
      time: '11:30 AM',
      amount: 'EGP 80',
      extraction: 'EGP 5',
    ),
    DailyEarningServiceModel(
      serviceName: 'Hair Color',
      customerName: 'Layla',
      time: '9:00 AM',
      amount: 'EGP 300',
      extraction: 'EGP 80',
    ),
    DailyEarningServiceModel(
      serviceName: 'Beard Design',
      customerName: 'Ahmed',
      time: '2:00 PM',
      amount: 'EGP 120',
      extraction: 'EGP 10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          ..._services.map(
            (service) => _DailyServiceItemWidget(service: service),
          ),
        ],
      ),
    );
  }
}

class _DailyServiceItemWidget extends StatelessWidget {
  final DailyEarningServiceModel service;

  const _DailyServiceItemWidget({required this.service});

  @override
  Widget build(BuildContext context) {
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
                    Text(service.time, style: TextStyles.font12greyColorA3W400),
                  ],
                ),
                verticalSpace(2),
                Text(
                  '${context.tr('myEarning.extraction')}: -${service.extraction}',
                  style: TextStyles.font10greyColorA3w400.copyWith(
                    color: AppColors.greyColor300,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Text(service.amount, style: TextStyles.font14greenColor500Weight600),
        ],
      ),
    );
  }
}
