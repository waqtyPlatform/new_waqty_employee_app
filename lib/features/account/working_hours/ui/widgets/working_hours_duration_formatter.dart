class WorkingHoursDurationFormatter {
  const WorkingHoursDurationFormatter._();

  static String format(int minutes) {
    final safeMinutes = minutes < 0 ? 0 : minutes;
    final hours = safeMinutes ~/ 60;
    final restMinutes = safeMinutes % 60;
    return '${hours}h ${restMinutes}m';
  }
}
