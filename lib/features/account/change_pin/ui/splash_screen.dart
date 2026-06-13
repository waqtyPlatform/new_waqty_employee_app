import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeUser());
  }

  Future<void> _routeUser() async {
    final String token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (!mounted) return;

    if (token.isEmpty) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
      return;
    }

    final isPinEnabled = await getIt<AppPinService>().isPinEnabled();
    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      isPinEnabled ? Routes.enterAppPinScreen : Routes.mainNavigationScreen,
      (route) => false,
      arguments: isPinEnabled ? null : {'pinVerified': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              color: AppColors.greenColor500,
              size: 54.r,
            ),
            SizedBox(height: 12.h),
            Text('Waqty', style: TextStyles.font24greyColor900Weight600),
            SizedBox(height: 18.h),
            SizedBox(
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: AppColors.greenColor500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
