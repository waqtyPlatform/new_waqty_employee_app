import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_waqty_employee_app/core/services/check_network.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_router_service.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/widgets/no_internet_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/biometric_lock_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/biometric_settings_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/disable_biometric_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/enable_biometric_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_service.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/change_app_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/create_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/disable_app_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/enter_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/security_settings_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/splash_screen.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_cubit.dart';
import 'package:new_waqty_employee_app/features/account/attendance/ui/attendance_screen.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/logic/branch_contact_cubit.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/branch_contact_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/change_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/contact_manager_screen.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_cubit.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/my_services_screen.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/logic/notification_setting_cubit.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/ui/notification_setting_screen.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/logic/profile_details_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/ui/profile_details_screen.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/report_bug_screen.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/shift_details_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/shift_details_screen.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/working_hours_screen.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/login_screen.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/search/logic/employee_search_cubit.dart';
import 'package:new_waqty_employee_app/features/search/ui/employee_search_screen.dart';
import 'package:new_waqty_employee_app/features/home/ui/home_screen.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/profile_screen.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/logic/forget_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/ui/forget_password_screen.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/ui/verify_code_screen.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/ui/reset_password_screen.dart';
import 'package:new_waqty_employee_app/features/main_navigation/ui/screens/main_navigation_screen.dart';
import 'package:new_waqty_employee_app/features/notifications/ui/notifications_screen.dart';
import 'package:new_waqty_employee_app/features/notifications/ui/notification_details_screen.dart';
import 'package:new_waqty_employee_app/features/notifications/logic/notifications_cubit.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/booking_details_screen.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/data/repo/bonuses_repo.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/data/services/bonuses_service.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_cubit.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/ui/bonuses_screen.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_details_args.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/repo/daily_earning_details_repo.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/services/daily_earning_details_service.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/daily_earning_details_screen.dart';
import 'package:new_waqty_employee_app/features/money/deductions/data/repo/deductions_repo.dart';
import 'package:new_waqty_employee_app/features/money/deductions/data/services/deductions_service.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/deductions/ui/deductions_screen.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/data/repo/earning_trend_repo.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/data/services/earning_trend_service.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_cubit.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/earning_trend_details_screen.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/data/repo/payslip_details_repo.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/data/services/payslip_details_service.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/logic/payslip_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/ui/payslip_details_screen.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/models/payslip_model.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/repo/payslips_repo.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/services/payslips_service.dart';
import 'package:new_waqty_employee_app/features/money/payslips/logic/payslips_cubit.dart';
import 'package:new_waqty_employee_app/features/money/payslips/ui/payslips_screen.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_cubit.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/ui/my_reviews_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // To prevent cast errors if arguments are null or not a map
    final dynamic args = settings.arguments ?? <String, dynamic>{};
    if (_shouldOpenNoInternet(settings.name)) {
      return MaterialPageRoute(
        builder: (context) => NoInternetScreen(
          onTryAgain: () async {
            if (!MyConnectivity.isOnline()) return;
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(
              context,
              settings.name!,
              arguments: settings.arguments,
            );
          },
        ),
      );
    }

    switch (settings.name) {
      case Routes.noInternetScreen:
        return MaterialPageRoute(builder: (_) => const NoInternetScreen());

      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.mainNavigationScreen:
        final isPinVerified = args is Map && args['pinVerified'] == true;
        final isSecurityVerified =
            args is Map && args['securityVerified'] == true;
        final initialIndex = args is Map
            ? int.tryParse(args['initialIndex']?.toString() ?? '') ?? 0
            : 0;
        return MaterialPageRoute(
          builder: (_) => _MainNavigationGate(
            isPinVerified: isPinVerified,
            isSecurityVerified: isSecurityVerified,
            initialIndex: initialIndex,
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  HomeCubit(getIt())..init(languageCode: languageCode),
              child: const HomeScreen(),
            );
          },
        );

      case Routes.employeeSearchScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) => EmployeeSearchCubit(getIt())..init(languageCode),
              child: const EmployeeSearchScreen(),
            );
          },
        );

      case Routes.notificationsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  NotificationsCubit(getIt())..init(languageCode: languageCode),
              child: const NotificationsScreen(),
            );
          },
        );

      case Routes.notificationDetailsScreen:
        final notification = args is Map
            ? args['notification'] as NotificationInboxItemModel?
            : null;
        if (notification == null) {
          return MaterialPageRoute(
            builder: (_) => _NotificationFallbackGate(
              messageKey: 'notificationInbox.resourceUnavailable',
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => NotificationDetailsScreen(notification: notification),
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(getIt()),
            child: const LoginScreen(),
          ),
        );

      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCubit(getIt()),
            child: const ForgetPasswordScreen(),
          ),
        );

      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileCubit(getIt())..init(),
            child: const ProfileScreen(),
          ),
        );

      case Routes.verifyCodeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VerifyCodeCubit(getIt(), getIt()),
            child: VerifyCodeScreen(email: args['email']),
          ),
        );

      case Routes.resetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ResetPasswordCubit(getIt()),
            child: ResetPasswordScreen(
              email: args['email'],
              code: args['code'],
            ),
          ),
        );

      case Routes.bookingDetailsScreen:
        final uuid = args is Map ? args['uuid']?.toString() ?? '' : '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                BookingDetailsCubit(getIt())..getBookingDetails(uuid),
            child: const BookingDetailsScreen(),
          ),
        );

      case Routes.myServicesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MyServicesCubit(getIt())..init(),
            child: const MyServicesScreen(),
          ),
        );

      case Routes.profileDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileDetailsCubit(getIt())..getProfile(),
            child: const ProfileDetailsScreen(),
          ),
        );

      case Routes.workingHoursScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  WorkingHoursCubit(getIt())..init(languageCode: languageCode),
              child: const WorkingHoursScreen(),
            );
          },
        );

      case Routes.shiftDetailsScreen:
        final shiftId = args is Map ? args['shiftId']?.toString() ?? '' : '';
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  ShiftDetailsCubit(getIt())
                    ..init(shiftId: shiftId, languageCode: languageCode),
              child: const ShiftDetailsScreen(),
            );
          },
        );

      case Routes.attendanceScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      AttendanceCubit(getIt())
                        ..init(languageCode: languageCode),
                ),
                BlocProvider(
                  create: (_) =>
                      ProfileCubit(getIt())..checkCurrentAttendance(),
                ),
              ],
              child: const AttendanceScreen(),
            );
          },
        );

      case Routes.branchContactScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  BranchContactCubit(getIt())..getBranchContact(languageCode),
              child: const BranchContactScreen(),
            );
          },
        );

      case Routes.contactManagerScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  ContactManagerCubit(getIt())
                    ..init(languageCode: languageCode),
              child: const ContactManagerScreen(),
            );
          },
        );

      case Routes.reportBugScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  ReportBugCubit(getIt())..init(languageCode: languageCode),
              child: const ReportBugScreen(),
            );
          },
        );

      case Routes.notificationSettingScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  NotificationSettingCubit(getIt())
                    ..getNotificationSettings(languageCode),
              child: const NotificationSettingScreen(),
            );
          },
        );

      case Routes.changePinCurrentScreen:
        return MaterialPageRoute(
          builder: (_) => const ChangePinScreen(step: ChangePinStep.currentPin),
        );

      case Routes.changePinNewScreen:
        return MaterialPageRoute(
          builder: (_) => const ChangePinScreen(step: ChangePinStep.newPin),
        );

      case Routes.changePinConfirmScreen:
        return MaterialPageRoute(
          builder: (_) => const ChangePinScreen(step: ChangePinStep.confirmPin),
        );

      case Routes.securitySettingsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AppPinCubit(getIt(), getIt())..loadSecuritySettings(),
            child: const SecuritySettingsScreen(),
          ),
        );

      case Routes.enterAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const EnterPinScreen(),
          ),
        );

      case Routes.createAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const CreatePinScreen(),
          ),
        );

      case Routes.changeAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const ChangeAppPinScreen(),
          ),
        );

      case Routes.disableAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const DisableAppPinScreen(),
          ),
        );

      case Routes.biometricSettingsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AppPinCubit(getIt(), getIt())..loadSecuritySettings(),
            child: const BiometricSettingsScreen(),
          ),
        );

      case Routes.biometricLockScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const BiometricLockScreen(),
          ),
        );

      case Routes.enableBiometricScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const EnableBiometricScreen(),
          ),
        );

      case Routes.disableBiometricScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AppPinCubit(getIt(), getIt())..loadSecuritySettings(),
            child: const DisableBiometricScreen(),
          ),
        );

      case Routes.earningTrendDetailsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            final month = args is Map ? args['month']?.toString() : null;
            return BlocProvider(
              create: (_) => EarningTrendCubit(
                EarningTrendRepo(EarningTrendService(apiConsumer: getIt())),
              )..init(languageCode: languageCode, month: month),
              child: const EarningTrendDetailsScreen(),
            );
          },
        );

      case Routes.dailyEarningDetailsScreen:
        final dailyArgs = args is Map
            ? DailyEarningDetailsArgs.fromMap(args)
            : const DailyEarningDetailsArgs(
                dateKey: 'recentTue3Mar',
                appointmentsKey: 'appointments7',
                amount: 'EGP 680',
              );
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) => DailyEarningDetailsCubit(
                DailyEarningDetailsRepo(
                  DailyEarningDetailsService(apiConsumer: getIt()),
                ),
              )..init(date: dailyArgs.date, languageCode: languageCode),
              child: DailyEarningDetailsScreen(args: dailyArgs),
            );
          },
        );

      case Routes.payslipsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) => PayslipsCubit(
                PayslipsRepo(PayslipsService(apiConsumer: getIt())),
              )..init(languageCode: languageCode),
              child: const PayslipsScreen(),
            );
          },
        );

      case Routes.payslipDetailsScreen:
        final payslipArgs = args is Map
            ? PayslipDetailsArgs.fromMap(args)
            : const PayslipDetailsArgs(
                monthKey: 'payslipFebruary2026',
                amount: 'EGP 5,120',
                isPaid: true,
              );
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  PayslipDetailsCubit(
                    PayslipDetailsRepo(
                      PayslipDetailsService(apiConsumer: getIt()),
                    ),
                  )..loadDetails(
                    uuid: payslipArgs.uuid,
                    languageCode: languageCode,
                  ),
              child: PayslipDetailsScreen(args: payslipArgs),
            );
          },
        );

      case Routes.bonusesScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) => BonusesCubit(
                BonusesRepo(BonusesService(apiConsumer: getIt())),
              )..init(languageCode: languageCode),
              child: const BonusesScreen(),
            );
          },
        );

      case Routes.deductionsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) => DeductionsCubit(
                DeductionsRepo(DeductionsService(apiConsumer: getIt())),
              )..init(languageCode: languageCode),
              child: const DeductionsScreen(),
            );
          },
        );

      case Routes.myReviewsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final languageCode = context.locale.languageCode;
            return BlocProvider(
              create: (_) =>
                  MyReviewsCubit(getIt())..init(languageCode: languageCode),
              child: const MyReviewsScreen(),
            );
          },
        );

      default:
        return null;
    }
  }

  static bool _shouldOpenNoInternet(String? routeName) {
    if (MyConnectivity.isOnline()) return false;
    return routeName != null &&
        routeName != Routes.splashScreen &&
        routeName != Routes.noInternetScreen;
  }
}

class _MainNavigationGate extends StatefulWidget {
  final bool isPinVerified;
  final bool isSecurityVerified;
  final int initialIndex;

  const _MainNavigationGate({
    required this.isPinVerified,
    required this.isSecurityVerified,
    required this.initialIndex,
  });

  @override
  State<_MainNavigationGate> createState() => _MainNavigationGateState();
}

class _MainNavigationGateState extends State<_MainNavigationGate> {
  AppLockDestination? _destination;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestination();
  }

  Future<void> _loadDestination() async {
    final destination = await getIt<AppPinService>().decideAppLockDestination();
    if (!mounted) return;
    setState(() {
      _destination = destination;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const _RouteLoadingScreen();

    final destination = _destination ?? AppLockDestination.login;
    if (destination == AppLockDestination.login) {
      return BlocProvider(
        create: (context) => LoginCubit(getIt()),
        child: const LoginScreen(),
      );
    }

    final isVerified = widget.isSecurityVerified || widget.isPinVerified;
    if (destination == AppLockDestination.biometric && !isVerified) {
      return BlocProvider(
        create: (_) => AppPinCubit(getIt(), getIt()),
        child: const BiometricLockScreen(),
      );
    }

    if (destination == AppLockDestination.pin && !isVerified) {
      return BlocProvider(
        create: (_) => AppPinCubit(getIt(), getIt()),
        child: const EnterPinScreen(),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getIt.isRegistered<NotificationRouterService>()) {
        getIt<NotificationRouterService>().flushPendingPayload();
      }
    });
    return MainNavigationScreen(initialIndex: widget.initialIndex);
  }
}

class _RouteLoadingScreen extends StatelessWidget {
  const _RouteLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _NotificationFallbackGate extends StatelessWidget {
  final String messageKey;

  const _NotificationFallbackGate({required this.messageKey});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, Routes.notificationsScreen);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text(context.tr(messageKey))),
    );
  }
}
