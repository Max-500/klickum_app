class Raffle {
  final String id;
  final String reward;
  final double price;
  final int amount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Raffle({required this.id, required this.reward, required this.price, required this.amount, required this.isActive, required this.createdAt, required this.updatedAt});
}