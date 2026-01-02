class Variant {
  final String id;
  final String sku;
  final double price;
  final int amount;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;

  Variant({required this.id, required this.sku, required this.price, required this.amount, required this.size, required this.createdAt, required this.updatedAt});
}