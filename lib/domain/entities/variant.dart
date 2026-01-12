class Variant {
  final int id;
  final String sku;
  final double price;
  final int amount;
  final String? size;
  final DateTime createdAt;
  final DateTime updatedAt;

  Variant({required this.id, required this.sku, required this.price, required this.amount, required this.size, required this.createdAt, required this.updatedAt});
}