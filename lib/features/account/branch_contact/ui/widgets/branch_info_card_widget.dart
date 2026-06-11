import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/models/branch_contact_response_model.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class BranchInfoCardWidget extends StatelessWidget {
  final BranchContactModel branchContact;

  const BranchInfoCardWidget({super.key, required this.branchContact});

  @override
  Widget build(BuildContext context) {
    final address = branchContact.address?.trim().isNotEmpty == true
        ? branchContact.address!
        : context.tr('branchContact.noAddress');

    final phone = branchContact.phone?.trim().isNotEmpty == true
        ? branchContact.phone!
        : context.tr('branchContact.noPhone');
    final mapUrl = branchContact.mapUrl?.trim();
    final hasMapUrl = mapUrl != null && mapUrl.isNotEmpty;

    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconCircle(
                icon: Icons.apartment_outlined,
                color: AppColors.greenColor500,
              ),
              horizontalSpace(8),
              Text(
                branchContact.name,
                style: TextStyles.font14greyColor900Weight600,
              ),
            ],
          ),
          verticalSpace(14),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: address,
            onTap: hasMapUrl
                ? () => AppConstant.openUrl(mapUrl)
                : branchContact.latitude != null &&
                      branchContact.longitude != null
                ? () => AppConstant.openMap(
                    branchContact.latitude!,
                    branchContact.longitude!,
                  )
                : null,
          ),
          verticalSpace(10),
          _InfoRow(icon: Icons.phone_outlined, text: phone),
          if (hasMapUrl) ...[
            verticalSpace(10),
            _InfoRow(
              icon: Icons.map_outlined,
              text: context.tr('branchContact.openGoogleMap'),
              onTap: () => AppConstant.openUrl(mapUrl),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _InfoRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: AppColors.greyColorA3),
          horizontalSpace(8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColorA3W400,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconCircle({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.r,
      width: 32.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greenColor5005,
      ),
      child: Icon(icon, size: 16.r, color: color),
    );
  }
}
