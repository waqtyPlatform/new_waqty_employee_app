class DailyEarningDetailsArgs {
  final String date;
  final String dateKey;
  final String appointmentsKey;
  final String amount;

  const DailyEarningDetailsArgs({
    this.date = '',
    required this.dateKey,
    required this.appointmentsKey,
    required this.amount,
  });

  factory DailyEarningDetailsArgs.fromMap(Map<dynamic, dynamic> map) {
    return DailyEarningDetailsArgs(
      date: map['date']?.toString() ?? '',
      dateKey: map['dateKey']?.toString() ?? 'recentTue3Mar',
      appointmentsKey: map['appointmentsKey']?.toString() ?? 'appointments7',
      amount: map['amount']?.toString() ?? '-',
    );
  }
}
