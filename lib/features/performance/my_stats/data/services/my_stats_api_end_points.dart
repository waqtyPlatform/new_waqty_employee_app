class MyStatsApiEndPoints {
  static String performance({required String period}) {
    return '/api/employee/performance?period=$period';
  }
}
