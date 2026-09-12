import 'package:flutter/widgets.dart';
import 'package:new_waqty_employee_app/my_app.dart';

class AppLanguage {
  const AppLanguage._();

  static String get currentCode {
    final context = navigatorKey.currentContext;
    final locale = context == null
        ? null
        : Localizations.maybeLocaleOf(context);
    return locale?.languageCode == 'en' ? 'en' : 'ar';
  }
}
