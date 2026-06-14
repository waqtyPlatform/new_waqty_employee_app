enum PayslipStatus { paid, pending }

class PayslipModel {
  final String monthKey;
  final String amount;
  final PayslipStatus status;

  const PayslipModel({
    required this.monthKey,
    required this.amount,
    required this.status,
  });

  bool get isPaid => status == PayslipStatus.paid;

  Map<String, dynamic> toRouteArguments() {
    return {'monthKey': monthKey, 'amount': amount, 'isPaid': isPaid};
  }
}

class PayslipDetailsArgs {
  final String monthKey;
  final String amount;
  final bool isPaid;

  const PayslipDetailsArgs({
    required this.monthKey,
    required this.amount,
    required this.isPaid,
  });

  factory PayslipDetailsArgs.fromMap(Map<dynamic, dynamic> map) {
    return PayslipDetailsArgs(
      monthKey: map['monthKey']?.toString() ?? 'payslipFebruary2026',
      amount: map['amount']?.toString() ?? 'EGP 5,120',
      isPaid: map['isPaid'] == true,
    );
  }
}
