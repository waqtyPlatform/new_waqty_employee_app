class DailyEarningServiceModel {
  final String serviceName;
  final String customerName;
  final String time;
  final String amount;
  final String extraction;

  const DailyEarningServiceModel({
    required this.serviceName,
    required this.customerName,
    required this.time,
    required this.amount,
    required this.extraction,
  });
}
