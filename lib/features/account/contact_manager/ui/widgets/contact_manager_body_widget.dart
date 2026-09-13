import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/widgets/contact_manager_messages_widget.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/widgets/contact_manager_priority_widget.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/widgets/contact_manager_subject_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_text_area_widget.dart';

class ContactManagerBodyWidget extends StatelessWidget {
  const ContactManagerBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactManagerCubit, ContactManagerState>(
      buildWhen: (previous, current) =>
          current is ContactManagerViewChangedState ||
          current is ContactManagerMessagesLoadingState ||
          current is ContactManagerMessagesSuccessState ||
          current is ContactManagerMessagesErrorState ||
          current is ContactManagerMessagesPaginationLoadingState ||
          current is ContactManagerMessagesPaginationSuccessState,
      builder: (context, state) {
        final cubit = ContactManagerCubit.get(context);
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: _ContactManagerViewSwitch(cubit: cubit),
            ),
            Expanded(
              child: cubit.showRequests
                  ? const ContactManagerMessagesWidget()
                  : _ContactManagerFormWidget(cubit: cubit),
            ),
          ],
        );
      },
    );
  }
}

class _ContactManagerFormWidget extends StatelessWidget {
  final ContactManagerCubit cubit;

  const _ContactManagerFormWidget({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Column(
        children: [
          const ContactManagerSubjectWidget(),
          verticalSpace(12),
          AccountSupportTextAreaWidget(
            titleKey: 'contactManager.message',
            hintKey: 'contactManager.messagePlaceholder',
            showCounter: true,
            controller: cubit.messageController,
          ),
          verticalSpace(12),
          const ContactManagerPriorityWidget(),
        ],
      ),
    );
  }
}

class _ContactManagerViewSwitch extends StatelessWidget {
  final ContactManagerCubit cubit;

  const _ContactManagerViewSwitch({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SwitchButton(
            title: context.tr('contactManager.newRequest'),
            isSelected: !cubit.showRequests,
            onTap: () => cubit.changeView(false),
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _SwitchButton(
            title: context.tr('contactManager.myRequests'),
            isSelected: cubit.showRequests,
            onTap: () => cubit.changeView(true),
          ),
        ),
      ],
    );
  }
}

class _SwitchButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SwitchButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor500 : AppColors.greyColorFA,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? AppColors.greenColor500 : AppColors.greyColorF5,
            width: .8.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyles.font12greyColor900Weight600.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.greyColor500,
          ),
        ),
      ),
    );
  }
}
