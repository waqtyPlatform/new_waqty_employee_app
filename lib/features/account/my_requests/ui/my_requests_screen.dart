import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/logic/my_requests_cubit.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/logic/my_requests_state.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/ui/widgets/my_requests_body_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_primary_button_widget.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      MyRequestsCubit.get(context).getCurrentSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const AccountSupportHeaderWidget(titleKey: 'myRequests.title'),
            const Expanded(child: MyRequestsBodyWidget()),
            BlocConsumer<MyRequestsCubit, MyRequestsState>(
              listenWhen: (previous, current) =>
                  current is MyRequestsSubmitSuccessState ||
                  current is MyRequestsSubmitErrorState,
              listener: (context, state) {
                final isSuccess = state is MyRequestsSubmitSuccessState;
                AppConstant.toast(
                  isSuccess
                      ? context.tr('myRequests.sent')
                      : (state as MyRequestsSubmitErrorState).message,
                  isSuccess,
                  context,
                );
              },
              buildWhen: (previous, current) =>
                  current is MyRequestsTabChangedState ||
                  current is MyRequestsSessionSuccessState ||
                  current is MyRequestsSubmitLoadingState ||
                  current is MyRequestsSubmitSuccessState ||
                  current is MyRequestsSubmitErrorState,
              builder: (context, state) {
                final cubit = MyRequestsCubit.get(context);
                if (cubit.selectedTab == MyRequestsTab.leave ||
                    !cubit.canSubmitEarlyDeparture) {
                  return const SizedBox.shrink();
                }
                return AccountSupportPrimaryButtonWidget(
                  textKey: 'myRequests.sendEarlyDeparture',
                  icon: Icons.send_outlined,
                  isLoading: cubit.isSubmitting,
                  onTap: () => cubit.submitEarlyDeparture(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
