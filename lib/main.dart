import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/my_app.dart';

import 'core/services/cache_helper.dart';
import 'core/services/check_network.dart';
import 'core/services/services_locator.dart';
import 'core/utils/app_constant.dart';
import 'observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();
  await ServicesLocator.init();
  // await BluetoothPermissionHandler.init(false);

  await CacheHelper.init();
  await MyConnectivity.initialise();
  Bloc.observer = Observer();

  await checkIfLoggedInUser();
  // End locations
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'), // English second1
        Locale('ar', 'EG'), // Arabic first
      ],
      saveLocale: true,
      startLocale: const Locale('ar', 'EG'),
      path: 'assets/languages',
      fallbackLocale: const Locale('ar', 'EG'),
      child: MyApp(
        navigateWidget: isLoggedInUser
            ? Routes.loginScreen
            : Routes.loginScreen,
      ),
    ),
  );
}

checkIfLoggedInUser() async {
  String? userToken = await CacheHelper.getSecuredString(
    ConstantKeys.saveTokenToShared,
  );
  if (!userToken.isNullOrEmpty()) {
    isLoggedInUser = true;
  } else {
    isLoggedInUser = false;
  }
}
