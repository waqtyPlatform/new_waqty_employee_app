import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/my_services_shimmer_loading.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/logic/notification_setting_cubit.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/logic/notification_setting_state.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/ui/widgets/notification_setting_list_widget.dart';

class NotificationSettingBodyWidget extends StatelessWidget {
  const NotificationSettingBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationSettingCubit, NotificationSettingState>(
      buildWhen: (previous, current) =>
          current is GetNotificationSettingLoadingState ||
          current is GetNotificationSettingSuccessState ||
          current is GetNotificationSettingErrorState ||
          current is GetNotificationSettingCatchErrorState ||
          current is UpdateNotificationSettingLoadingState ||
          current is UpdateNotificationSettingSuccessState ||
          current is UpdateNotificationSettingErrorState ||
          current is UpdateNotificationSettingCatchErrorState,
      builder: (context, state) {
        final cubit = NotificationSettingCubit.get(context);
        final settings = cubit.notificationSettings;

        if (settings == null && state is GetNotificationSettingLoadingState) {
          return const MyServicesShimmerLoading();
        }

        if (settings == null) {
          return Center(
            child: Text(
              context.tr('notifications.title'),
              style: TextStyles.font16greyColor900Weight400,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: () async {
            cubit.getNotificationSettings(context.locale.languageCode);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: NotificationSettingListWidget(
              settings: settings,
              updatingKey: cubit.updatingKey,
              onChanged: cubit.updateNotificationSetting,
            ),
          ),
        );
      },
    );
  }
}
