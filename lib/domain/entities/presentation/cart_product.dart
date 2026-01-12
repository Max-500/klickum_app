import 'package:klicum/domain/entities/variant.dart';

class CartProduct {
  final String name;
  final int amount;
  final double price;
  final Variant variant;
  

  CartProduct({ required this.name, required this.amount, required this.variant, required this.price });

  CartProduct copyWith({
    int? amount, Variant? variant, double? price, String? name
  }) => CartProduct(amount: amount ?? this.amount, variant: variant ?? this.variant, price: price ?? this.price, name: name ?? this.name);

  Map<String, dynamic> toJson() => {
    "productVariantId": variant.id,
    "amount": amount,
  };
}