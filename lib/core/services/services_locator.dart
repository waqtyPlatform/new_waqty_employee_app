import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';

import '../api/api_consumer.dart';
import '../api/app_interceptor.dart';
import '../api/http_consumer.dart';

import 'package:new_waqty_employee_app/features/login/data/repo/login_repo.dart';
import 'package:new_waqty_employee_app/features/login/data/services/login_service.dart';

import 'package:new_waqty_employee_app/features/home/data/repo/home_repo.dart';
import 'package:new_waqty_employee_app/features/home/data/services/home_service.dart';

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
  }
}
