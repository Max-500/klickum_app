import 'package:klicum/domain/entities/presentation/cart_product.dart';

abstract class OrderRepository {
  Future<void> createOrder({ required Map<int, CartProduct> variants, required String addressID });
}