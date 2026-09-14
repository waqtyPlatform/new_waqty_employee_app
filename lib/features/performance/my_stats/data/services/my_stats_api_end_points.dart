class MyStatsApiEndPoints {
  static String performance({required String period}) {
    return '/employee/performance?period=$period';
  }
}
