class DailyEarningDetailsArgs {
  final String dateKey;
  final String appointmentsKey;
  final String amount;

  const DailyEarningDetailsArgs({
    required this.dateKey,
    required this.appointmentsKey,
    required this.amount,
  });

  factory DailyEarningDetailsArgs.fromMap(Map<dynamic, dynamic> map) {
    return DailyEarningDetailsArgs(
      dateKey: map['dateKey']?.toString() ?? 'recentTue3Mar',
      appointmentsKey: map['appointmentsKey']?.toString() ?? 'appointments7',
      amount: map['amount']?.toString() ?? 'EGP 680',
    );
  }
}
