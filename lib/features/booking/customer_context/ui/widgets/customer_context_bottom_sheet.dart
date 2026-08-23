import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/models/customer_context_model.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/logic/customer_context_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/logic/customer_context_state.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/ui/widgets/customer_package_card_widget.dart';

Future<bool?> showCustomerContextBottomSheet({
  required BuildContext context,
  required String customerUuid,
  bool startWithAddPackage = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => CustomerContextCubit(getIt())
        ..getCustomerContext(
          customerUuid: customerUuid,
          languageCode: context.locale.languageCode,
        ),
      child: CustomerContextBottomSheet(
        startWithAddPackage: startWithAddPackage,
      ),
    ),
  );
}

class CustomerContextBottomSheet extends StatefulWidget {
  final bool startWithAddPackage;

  const CustomerContextBottomSheet({
    super.key,
    this.startWithAddPackage = false,
  });

  @override
  State<CustomerContextBottomSheet> createState() =>
      _CustomerContextBottomSheetState();
}

class _CustomerContextBottomSheetState
    extends State<CustomerContextBottomSheet> {
  bool _showAddPackage = false;
  bool _notifiedInitialAdd = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerContextCubit, CustomerContextState>(
      listener: (context, state) {
        if (state is CustomerPackageAssignSuccessState) {
          AppConstant.toast(
            context.tr('customerContext.packageAddedSuccessfully'),
            true,
            context,
          );
          setState(() => _showAddPackage = false);
          Navigator.pop(context, true);
        } else if (state is CustomerPackageAssignErrorState ||
            state is CustomerContextErrorState) {
          AppConstant.toast(
            CustomerContextCubit.get(context).errorMessage.isEmpty
                ? context.tr('common.errorMessage')
                : CustomerContextCubit.get(context).errorMessage,
            false,
            context,
          );
        }
      },
      builder: (context, state) {
        final cubit = CustomerContextCubit.get(context);
        final data = cubit.contextData;
        if (widget.startWithAddPackage &&
            !_notifiedInitialAdd &&
            data != null &&
            data.capabilities.canAssignCustomerPackage) {
          _notifiedInitialAdd = true;
          _showAddPackage = true;
        }

        return Container(
          height: MediaQuery.sizeOf(context).height * .86,
          padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 24.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  width: 70.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColorE5,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                verticalSpace(18),
                Row(
                  children: [
                    Text(
                      context.tr('customerContext.customerDetails'),
                      style: TextStyles.font18greyColor900Weight600,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 20.r),
                    ),
                  ],
                ),
                Expanded(child: _buildContent(context, state, cubit, data)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    CustomerContextState state,
    CustomerContextCubit cubit,
    CustomerContextModel? data,
  ) {
    if (state is CustomerContextLoadingState && data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data == null) {
      return Center(
        child: Text(
          context.tr('bookingDetails.notFound'),
          style: TextStyles.font14greyColor500W500,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => cubit.getCustomerContext(
        customerUuid: cubit.customerUuid,
        languageCode: cubit.languageCode,
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _CustomerInfoCard(customer: data.customer),
          verticalSpace(12),
          if (data.capabilities.canViewCustomerPackages)
            _PackagesSection(
              data: data,
              showAddPackage: _showAddPackage,
              onToggleAddPackage: data.capabilities.canAssignCustomerPackage
                  ? () => setState(() => _showAddPackage = !_showAddPackage)
                  : null,
              onAssignPackage: _confirmAssignPackage,
            ),
          if (data.capabilities.canViewCustomerFollowUps) ...[
            verticalSpace(12),
            _FollowUpsSection(followUps: data.followUps),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmAssignPackage(
    BuildContext context,
    AssignableCustomerPackageModel package,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr('customerContext.confirmAddPackage')),
        content: Text(
          '${package.name}\n${_packageTypeLabel(context, package.type)}\n'
          '${package.currency} ${package.price}\n\n'
          '${context.tr('customerContext.waitingCollectionNote')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('bookingDetails.back')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.tr('customerContext.addPackage')),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      CustomerContextCubit.get(context).assignPackage(package);
    }
  }
}

class _CustomerInfoCard extends StatelessWidget {
  final CustomerContextCustomerModel customer;

  const _CustomerInfoCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyles.font16greyColor900Weight600),
          verticalSpace(8),
          _InfoLine(
            label: context.tr('profileDetails.phoneNumber'),
            value: customer.phone,
          ),
          if (customer.email?.isNotEmpty == true)
            _InfoLine(label: context.tr('login.email'), value: customer.email!),
        ],
      ),
    );
  }
}

class _PackagesSection extends StatelessWidget {
  final CustomerContextModel data;
  final bool showAddPackage;
  final VoidCallback? onToggleAddPackage;
  final void Function(
    BuildContext context,
    AssignableCustomerPackageModel package,
  )
  onAssignPackage;

  const _PackagesSection({
    required this.data,
    required this.showAddPackage,
    this.onToggleAddPackage,
    required this.onAssignPackage,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.tr('customerContext.customerPackages'),
                style: TextStyles.font14greyColor900Weight600,
              ),
              const Spacer(),
              if (onToggleAddPackage != null)
                GestureDetector(
                  onTap: onToggleAddPackage,
                  child: Text(
                    '+ ${context.tr('customerContext.addPackage')}',
                    style: TextStyles.font12greenColor500W600,
                  ),
                ),
            ],
          ),
          verticalSpace(12),
          if (data.packages.isEmpty)
            Text(
              context.tr('customerContext.noPackages'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...data.packages.map(
              (package) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: CustomerPackageCardWidget(package: package),
              ),
            ),
          if (showAddPackage) ...[
            Divider(color: AppColors.greyColorF5),
            verticalSpace(8),
            Text(
              context.tr('customerContext.availablePackages'),
              style: TextStyles.font14greyColor900Weight600,
            ),
            verticalSpace(8),
            if (data.assignablePackages.isEmpty)
              Text(
                context.tr('customerContext.noAssignablePackages'),
                style: TextStyles.font12greyColorA3W400,
              )
            else
              ...data.assignablePackages.map(
                (package) => _AssignablePackageTile(
                  package: package,
                  onTap: () => onAssignPackage(context, package),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _AssignablePackageTile extends StatelessWidget {
  final AssignableCustomerPackageModel package;
  final VoidCallback onTap;

  const _AssignablePackageTile({required this.package, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        CustomerContextCubit.get(context).assigningPackageUuid == package.uuid;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColorF5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(4),
                  Text(
                    _assignableSubtitle(context, package),
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            isLoading
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    '${package.currency} ${package.price}',
                    style: TextStyles.font12greenColor500W600,
                  ),
          ],
        ),
      ),
    );
  }
}

class _FollowUpsSection extends StatelessWidget {
  final List<CustomerFollowUpModel> followUps;

  const _FollowUpsSection({required this.followUps});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('customerContext.followUps'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          if (followUps.isEmpty)
            Text(
              context.tr('customerContext.noFollowUps'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...followUps.map((followUp) => _FollowUpCard(followUp: followUp)),
        ],
      ),
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  final CustomerFollowUpModel followUp;

  const _FollowUpCard({required this.followUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  followUp.serviceName,
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              if (followUp.recommendedPeriodEnded)
                _SmallBadge(
                  label: context.tr('customerContext.recommendedPeriodEnded'),
                  color: AppColors.warningColor1001,
                ),
            ],
          ),
          verticalSpace(6),
          _InfoLine(
            label: context.tr('bookingDetails.added'),
            value: followUp.status,
          ),
          if (followUp.availableCount != null)
            _InfoLine(
              label: context.tr('customerContext.availableCount'),
              value: followUp.availableCount.toString(),
            ),
          if (followUp.validUntil.isNotEmpty)
            _InfoLine(
              label: context.tr('customerContext.validUntilLabel'),
              value: followUp.validUntil,
            ),
          if (followUp.employeeRule.isNotEmpty)
            _InfoLine(
              label: context.tr('customerContext.employeeRule'),
              value: followUp.employeeRule,
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        children: [
          Text(label, style: TextStyles.font12greyColorA3W400),
          const Spacer(),
          Flexible(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyles.font10greyColorA3W600.copyWith(color: color),
      ),
    );
  }
}

String _packageTypeLabel(BuildContext context, String type) {
  switch (type) {
    case 'multi_session':
      return context.tr('customerContext.multiSession');
    case 'usage_based':
      return context.tr('customerContext.usageBased');
    default:
      return type;
  }
}

String _assignableSubtitle(
  BuildContext context,
  AssignableCustomerPackageModel package,
) {
  if (package.type == 'multi_session') {
    return '${context.tr('customerContext.sessionsCount')}: ${package.sessionsIncluded ?? '-'}';
  }
  if (package.type == 'usage_based') {
    return '${context.tr('customerContext.totalUnits')}: ${package.initialUnits ?? '-'} ${package.unitName ?? package.unitCode ?? ''}';
  }
  return _packageTypeLabel(context, package.type);
}
