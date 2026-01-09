import 'package:klicum/domain/entities/product.dart';

class CartProduct {
  final int amount;
  final Product product;

  CartProduct({ required this.amount, required this.product });

  CartProduct copyWith({
    int? amount, Product? product
  }) => CartProduct(amount: amount ?? this.amount, product: product ?? this.product);
}