class RechargeIntentResponse {
  final String id;
  final int amount;
  final int serviceFee;
  final int total;
  final String clientSecret;
  final String status;
  final DateTime createdAt;

  RechargeIntentResponse({required this.id, required this.amount, required this.serviceFee, required this.total, required this.clientSecret, required this.status, required this.createdAt});

  factory RechargeIntentResponse.fromJson(Map<String, dynamic> json) {
    return RechargeIntentResponse(
      id: json['id'],
      amount: json['amount'],
      serviceFee: json['serviceFee'],
      total: json['total'],
      clientSecret: json['clientSecret'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

}