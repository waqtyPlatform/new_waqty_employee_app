import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';

import '../api/api_consumer.dart';
import '../api/app_interceptor.dart';
import '../api/http_consumer.dart';

import 'package:new_waqty_employee_app/features/auth/login/data/repo/login_repo.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/services/login_service.dart';

import 'package:new_waqty_employee_app/features/home/data/repo/home_repo.dart';
import 'package:new_waqty_employee_app/features/home/data/services/home_service.dart';

import 'package:new_waqty_employee_app/features/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/profile/data/services/profile_service.dart';

import 'package:new_waqty_employee_app/features/auth/forget_password/data/repo/forget_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/services/forget_password_service.dart';

import 'package:new_waqty_employee_app/features/auth/verify_code/data/repo/verify_code_repo.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/services/verify_code_service.dart';

import 'package:new_waqty_employee_app/features/auth/reset_password/data/repo/reset_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/services/reset_password_service.dart';

import 'package:new_waqty_employee_app/features/booking/my_booking/data/repo/my_booking_repo.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/services/my_booking_service.dart';

final getIt = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    /// Home
    getIt.registerLazySingleton<HomeService>(
      () => HomeService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));

    ///constant
    // getIt.registerLazySingleton<EndPoints>(() => EndPoints());
    getIt.registerLazySingleton<AppConstant>(() => AppConstant());
    getIt.registerLazySingleton<AppColors>(() => AppColors());

    ///core

    getIt.registerLazySingleton<AppInterceptor>(() => AppInterceptor());

    getIt.registerLazySingleton<ApiConsumer>(() => HttpConsumer(getIt()));
    getIt.registerLazySingleton(() => http.Client());

    ///shared secure
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    getIt.registerLazySingleton(() => secureStorage);

    /// Login
    getIt.registerLazySingleton<LoginService>(
      () => LoginService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));

    /// Profile
    getIt.registerLazySingleton<ProfileService>(
      () => ProfileService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));

    /// Forget Password
    getIt.registerLazySingleton<ForgetPasswordService>(
      () => ForgetPasswordService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(getIt()),
    );

    /// Verify Code
    getIt.registerLazySingleton<VerifyCodeService>(
      () => VerifyCodeService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<VerifyCodeRepo>(() => VerifyCodeRepo(getIt()));

    /// Reset Password
    getIt.registerLazySingleton<ResetPasswordService>(
      () => ResetPasswordService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ResetPasswordRepo>(
      () => ResetPasswordRepo(getIt()),
    );

    /// My Booking
    getIt.registerLazySingleton<MyBookingService>(
      () => MyBookingService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<MyBookingRepo>(() => MyBookingRepo(getIt()));
  }
}
