import 'package:klicum/domain/entities/presentation/cart_product.dart';

abstract class OrderDatasource {
  Future<void> createOrder({ required Map<int, CartProduct> variants, required String addressID });
}