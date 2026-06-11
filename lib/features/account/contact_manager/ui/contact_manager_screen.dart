import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/widgets/contact_manager_body_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_primary_button_widget.dart';

class ContactManagerScreen extends StatelessWidget {
  const ContactManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const AccountSupportHeaderWidget(titleKey: 'contactManager.title'),
            const Expanded(child: ContactManagerBodyWidget()),
            BlocConsumer<ContactManagerCubit, ContactManagerState>(
              listenWhen: (previous, current) =>
                  current is SendContactManagerMessageSuccessState ||
                  current is SendContactManagerMessageErrorState ||
                  current is SendContactManagerMessageCatchErrorState,
              listener: (context, state) {
                final isSuccess =
                    state is SendContactManagerMessageSuccessState;
                final messageKey = isSuccess
                    ? 'contactManager.messageSent'
                    : 'contactManager.messageFailed';
                AppConstant.toast(context.tr(messageKey), isSuccess, context);
              },
              buildWhen: (previous, current) =>
                  current is SendContactManagerMessageLoadingState ||
                  current is SendContactManagerMessageSuccessState ||
                  current is SendContactManagerMessageErrorState ||
                  current is SendContactManagerMessageCatchErrorState,
              builder: (context, state) {
                return AccountSupportPrimaryButtonWidget(
                  textKey: 'common.sendMessage',
                  icon: Icons.send_outlined,
                  isLoading: state is SendContactManagerMessageLoadingState,
                  onTap: () => ContactManagerCubit.get(
                    context,
                  ).sendMessage(context.locale.languageCode),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
