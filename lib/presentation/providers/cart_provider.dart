import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/product.dart';


final myCartProvider = NotifierProvider<MyCartProductsNotifier, Map<String, CartProduct>>(MyCartProductsNotifier.new);
class MyCartProductsNotifier extends Notifier <Map<String, CartProduct>>{
  @override
  Map<String, CartProduct> build() => {};

  void addProduct(Product product) {
    final updated = Map<String, CartProduct>.from(state);

    if (updated.containsKey(product.id)) {
      final cartProduct = updated[product.id]!;
      updated[product.id] = cartProduct.copyWith(amount: cartProduct.amount + 1);
    } else {
      updated[product.id] = CartProduct(amount: 1, product: product);
    }

    state = updated;
  }

  void increment(String id) {
    final updated = Map<String, CartProduct>.from(state);
    final current = updated[id];
    if (current == null) return;

    updated[id] = current.copyWith(amount: current.amount + 1);
    state = updated;
  }

  void decrement(String id) {
    final updated = Map<String, CartProduct>.from(state);
    final current = updated[id];
    if (current == null) return;

    if (current.amount <= 1) {
      updated.remove(id);
    } else {
      updated[id] = current.copyWith(amount: current.amount - 1);
    }

    state = updated;
  }
}