class RechargeIntent {
  final String id;
  final int amount;
  final int serviceFee;
  final int total;
  final String clientSecret;
  final String status;
  final DateTime createdAt;

  RechargeIntent({
    required this.id,
    required this.amount,
    required this.serviceFee,
    required this.total,
    required this.clientSecret,
    required this.status,
    required this.createdAt,
  });

}