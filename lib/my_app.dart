import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/check_network.dart';
import 'package:new_waqty_employee_app/core/widgets/offline_alert_dialog.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/app_white_theme.dart';
import 'core/utils/app_colors_white_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final String navigateWidget;

  const MyApp({required this.navigateWidget, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Map<String, bool>>? _networkSubscription;
  bool _wasOnline = MyConnectivity.isOnline();
  bool _isOfflineSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _listenToNetwork();
  }

  void _listenToNetwork() {
    _networkSubscription = MyConnectivity.myStream.listen((event) {
      final isOnline = event['result'] ?? MyConnectivity.isOnline();
      if (!isOnline && _wasOnline) {
        _showOfflineDialog();
      }
      if (isOnline && _isOfflineSheetVisible) {
        navigatorKey.currentState?.pop();
        _isOfflineSheetVisible = false;
      }
      _wasOnline = isOnline;
    });
  }

  Future<void> _showOfflineDialog() async {
    if (navigatorKey.currentContext == null) return;
    if (_isOfflineSheetVisible) return;
    _isOfflineSheetVisible = true;
    await OfflineAlertDialog.showBottomSheet();
    _isOfflineSheetVisible = false;
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, snapshot) {
        // getIt<AppConstant>().setLanguage(context.locale.languageCode);
        return Container(
          color: AppColors.whiteColor,
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: "appName".tr(),
            theme: themeData(),
            initialRoute: widget.navigateWidget,
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      },
    );
  }
}
