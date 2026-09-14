import 'package:new_waqty_employee_app/core/api/end_points.dart';

class MoneyApiEndPoints {
  MoneyApiEndPoints._();

  static String preview(String month) =>
      '${EndPoints.baseUrl}/employee/money/preview?month=$month';

  static String trend({required String period, required String month}) =>
      '${EndPoints.baseUrl}/employee/money/trend?period=$period&month=$month';

  static String daily(String date) =>
      '${EndPoints.baseUrl}/employee/money/daily?date=$date';

  static String payslips({int page = 1, int perPage = 15}) =>
      '${EndPoints.baseUrl}/employee/money/payslips?page=$page&per_page=$perPage';

  static String payslipDetails(String uuid) =>
      '${EndPoints.baseUrl}/employee/money/payslips/$uuid';

  static String bonuses({int page = 1, int perPage = 15}) =>
      '${EndPoints.baseUrl}/employee/money/bonuses?page=$page&per_page=$perPage';

  static String deductions({int page = 1, int perPage = 15}) =>
      '${EndPoints.baseUrl}/employee/money/deductions?page=$page&per_page=$perPage';
}
