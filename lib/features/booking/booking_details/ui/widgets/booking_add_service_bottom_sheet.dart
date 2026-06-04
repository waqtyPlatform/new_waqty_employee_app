import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/services_with_prices_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';

void showAddServiceBottomSheet(
  BuildContext context,
  BookingDetailsCubit cubit,
  String currency,
) {
  cubit.getServicesWithPrices(refresh: true);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.greyColor3004.withValues(alpha: .4),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: BookingAddServiceBottomSheet(currency: currency),
      );
    },
  );
}

class BookingAddServiceBottomSheet extends StatelessWidget {
  final String currency;

  const BookingAddServiceBottomSheet({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560.h,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
        buildWhen: (previous, current) {
          return current is OnServicesWithPricesLoadingState ||
              current is OnServicesWithPricesSuccessState ||
              current is OnServicesWithPricesPaginationLoadingState ||
              current is OnServicesWithPricesPaginationSuccessState ||
              current is OnBookingDetailsErrorState ||
              current is OnBookingDetailsCatchErrorState;
        },
        builder: (context, state) {
          final cubit = BookingDetailsCubit.get(context);

          return Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColorE5,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              verticalSpace(18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('bookingDetails.addService'),
                      style: TextStyles.font18greyColor900Weight600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.greyColorF5,
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyColor900,
                        size: 18.r,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              Expanded(child: _buildServicesContent(context, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildServicesContent(
    BuildContext context,
    BookingDetailsCubit cubit,
  ) {
    if (cubit.isServicesWithPricesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cubit.servicesWithPrices.isEmpty) {
      return Center(
        child: Text(
          context.tr('bookingDetails.noServicesFound'),
          style: TextStyles.font14greyColor500W500,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 80.h) {
          cubit.getServicesWithPrices();
        }
        return false;
      },
      child: ListView.separated(
        itemCount:
            cubit.servicesWithPrices.length +
            (cubit.isServicesWithPricesPaginationLoading ? 1 : 0),
        separatorBuilder: (_, _) =>
            Divider(height: 1.h, color: AppColors.greyColorF5),
        itemBuilder: (context, index) {
          if (index == cubit.servicesWithPrices.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return AddServiceItemWidget(
            service: cubit.servicesWithPrices[index],
            currency: currency,
          );
        },
      ),
    );
  }
}

class AddServiceItemWidget extends StatelessWidget {
  final ServiceWithPriceModel service;
  final String currency;

  const AddServiceItemWidget({
    super.key,
    required this.service,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AppColors.greenColor5005,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.add,
                color: AppColors.greenColor500,
                size: 18.r,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(4),
                  Text(
                    service.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            Text(
              '${context.tr('bookingDetails.min')} ${service.estimatedDurationMinutes}',
              style: TextStyles.font12greyColorA3W400,
            ),
            horizontalSpace(10),
            Text(
              '$currency ${service.pricing.finalPrice}',
              style: TextStyles.font14greyColor900Weight600,
            ),
          ],
        ),
      ),
    );
  }
}
