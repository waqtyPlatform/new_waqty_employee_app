import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/logic/branch_contact_cubit.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/logic/branch_contact_state.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/widgets/branch_call_button_widget.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/widgets/branch_info_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/widgets/branch_opening_hours_widget.dart';

class BranchContactBodyWidget extends StatelessWidget {
  const BranchContactBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchContactCubit, BranchContactState>(
      buildWhen: (previous, current) =>
          current is GetBranchContactLoadingState ||
          current is GetBranchContactSuccessState ||
          current is GetBranchContactErrorState ||
          current is GetBranchContactCatchErrorState,
      builder: (context, state) {
        final cubit = BranchContactCubit.get(context);
        final branchContact = cubit.branchContact;

        if (state is GetBranchContactLoadingState && branchContact == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenColor500),
          );
        }

        if (branchContact == null) {
          return Center(
            child: Text(
              context.tr('branchContact.notFound'),
              style: TextStyles.font14greyColor900Weight500,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: () async {
            cubit.getBranchContact(context.locale.languageCode);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BranchInfoCardWidget(branchContact: branchContact),
                verticalSpace(12),
                BranchOpeningHoursWidget(branchContact: branchContact),
                verticalSpace(12),
                BranchCallButtonWidget(phone: branchContact.phone),
              ],
            ),
          ),
        );
      },
    );
  }
}
