class RecentEarningModel {
  final String dateKey;
  final String appointmentsKey;
  final String? amount;

  const RecentEarningModel({
    required this.dateKey,
    required this.appointmentsKey,
    this.amount,
  });
}
