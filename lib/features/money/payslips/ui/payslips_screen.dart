import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/payslip_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslips/ui/widgets/payslips_list_widget.dart';
import 'package:new_waqty_employee_app/features/money/payslips/logic/payslips_cubit.dart';
import 'package:new_waqty_employee_app/features/money/payslips/logic/payslips_state.dart';

class PayslipsScreen extends StatelessWidget {
  const PayslipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<PayslipsCubit, PayslipsState>(
          buildWhen: (previous, current) =>
              current is PayslipsLoadingState ||
              current is PayslipsSuccessState ||
              current is PayslipsErrorState ||
              current is PayslipsLoadingMoreState,
          builder: (context, state) {
            if (state is PayslipsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.greenColor500,
                ),
              );
            }
            if (state is PayslipsErrorState) {
              return Center(child: Text(state.message));
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 120) {
                  context.read<PayslipsCubit>().loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                color: AppColors.greenColor500,
                onRefresh: () async =>
                    context.read<PayslipsCubit>().loadPayslips(refresh: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
                  child: Column(
                    children: [
                      const PayslipHeaderWidget(titleKey: 'myEarning.payslips'),
                      verticalSpace(16),
                      const PayslipsListWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
