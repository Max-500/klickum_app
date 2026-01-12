import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/variant.dart';

final myCartProvider = NotifierProvider<MyCartProductsNotifier, Map<int, CartProduct>>(MyCartProductsNotifier.new);
class MyCartProductsNotifier extends Notifier <Map<int, CartProduct>>{
  @override
  Map<int, CartProduct> build() => {};

  void addProduct(Variant variant, double? price, String? name) {
    final updated = Map<int, CartProduct>.from(state);

    final current = updated[variant.id];

    if (current != null) {
      updated[variant.id] = current.copyWith(
        amount: current.amount + 1,
      );
    } else {
      updated[variant.id] = CartProduct(
        amount: 1,
        variant: variant,
        price: price!,
        name: name!
      );
    }

    state = updated;
  }

  void decrement(int id) {
    final updated = Map<int, CartProduct>.from(state);
    final current = updated[id];
    if (current == null) return;

    if (current.amount <= 1) {
      updated.remove(id);
    } else {
      updated[id] = current.copyWith(amount: current.amount - 1);
    }

    state = updated;
  }

  void clear() => state = {};
}