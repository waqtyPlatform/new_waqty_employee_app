import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class ContactManagerPriorityWidget extends StatelessWidget {
  const ContactManagerPriorityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactManagerCubit, ContactManagerState>(
      buildWhen: (previous, current) =>
          current is ContactManagerPriorityChangedState,
      builder: (context, state) {
        final cubit = ContactManagerCubit.get(context);
        return AccountSupportCardWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('contactManager.priority'),
                style: TextStyles.font14greyColor900Weight600,
              ),
              verticalSpace(12),
              Row(
                children: [
                  Expanded(
                    child: _PriorityButton(
                      text: context.tr('contactManager.normal'),
                      isSelected: cubit.selectedPriority == 'normal',
                      onTap: () => cubit.changePriority('normal'),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: _PriorityButton(
                      text: context.tr('contactManager.urgent'),
                      isSelected: cubit.selectedPriority == 'urgent',
                      onTap: () => cubit.changePriority('urgent'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriorityButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor5005 : AppColors.greyColorF5,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected
                ? AppColors.successColor50
                : AppColors.greyColorFA,
            width: 0.8.w,
          ),
        ),
        child: Text(
          text,
          style: TextStyles.font14greyColorA3W400.copyWith(
            color: isSelected ? AppColors.greenColor500 : AppColors.greyColorA3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
