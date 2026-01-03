class RaffleResponse {
  final String id;
  final String reward;
  final double price;
  final int amount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  RaffleResponse({required this.id, required this.reward, required this.price, required this.amount, required this.isActive, required this.createdAt, required this.updatedAt});

  factory RaffleResponse.fromJson(Map<String, dynamic> json) => RaffleResponse(
    id: json['id'], 
    reward: json['name'], 
    price: double.tryParse((json['price'] ?? '').toString()) ?? -1, 
    amount: int.tryParse((json['amount'] ?? '').toString()) ?? -1, 
    isActive: json['isActive'], 
    createdAt: DateTime.parse(json['created_at']), 
    updatedAt: DateTime.parse(json['updated_at'])
  );
}