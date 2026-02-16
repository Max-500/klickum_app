import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/presentation/providers/repositories/cart_repository_provider.dart';

final myCartProvider = AsyncNotifierProvider<MyCartProductsNotifier, Map<int, CartProduct>>(MyCartProductsNotifier.new);
class MyCartProductsNotifier extends AsyncNotifier<Map<int, CartProduct>> {
  @override
  FutureOr<Map<int, CartProduct>> build() async {
    return await ref.read(cartRepositoryProvider).getProducts();
  }

  Map<int, CartProduct> _current() => state.value ?? <int, CartProduct>{};

  Future<void> increment(int id) async {
    final updated = Map<int, CartProduct>.from(_current());
    final current = updated[id];

    if (current == null) return;

    if (current.amount <= 1) {
      updated.remove(id);
    } else {
      await ref.read(cartRepositoryProvider).updateVariant(productVariantID: id, amount: current.amount, isIncrement: true);
      updated[id] = current.copyWith(amount: current.amount + 1);
    }

    state = AsyncData(updated);

  }

  Future<void> decrement(int productVariantID, String id) async {
    final updated = Map<int, CartProduct>.from(_current());
    final current = updated[productVariantID];
    if (current == null) return;

    if (current.amount <= 1) {
      await ref.read(cartRepositoryProvider).deleteVariant(id: id);
      updated.remove(productVariantID);
    } else {
      await ref.read(cartRepositoryProvider).updateVariant(productVariantID: productVariantID, amount: current.amount, isIncrement: false);
      updated[productVariantID] = current.copyWith(amount: current.amount - 1);
    }

    state = AsyncData(updated);
  }

  Future<void> clear() async => state = const AsyncData(<int, CartProduct>{});
}
