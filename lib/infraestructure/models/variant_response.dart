class VariantResponse {
  final String id;
  final String sku;
  final double price;
  final int amount;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;

  VariantResponse({required this.id, required this.sku, required this.price, required this.amount, required this.size, required this.createdAt, required this.updatedAt});

  factory VariantResponse.fromJson(Map<String, dynamic> json) => VariantResponse(
    id: json['id'].toString(), 
    sku: json['sku'] ?? '', 

    price: double.tryParse((json['price'] ?? '').toString()) ?? -1,
    amount: int.tryParse((json['amount'] ?? '').toString()) ?? -1,
    size: int.tryParse((json['size'] ?? '').toString()) ?? -1,

    createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(), 
    updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now()
  );
}