class WorkingHoursDurationFormatter {
  const WorkingHoursDurationFormatter._();

  static String format(int minutes) {
    final safeMinutes = minutes < 0 ? 0 : minutes;
    final hours = safeMinutes ~/ 60;
    final restMinutes = safeMinutes % 60;
    if (restMinutes == 0) {
      return '${hours}h';
    }
    if (hours == 0) {
      return '${restMinutes}m';
    }
    return '${hours}h ${restMinutes}m';
  }
}
