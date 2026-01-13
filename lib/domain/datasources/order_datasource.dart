import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/presentation/order_data.dart';

abstract class OrderDatasource {
  Future<void> createOrder({ required Map<int, CartProduct> variants, required String addressID });
  Future<OrderData> getOrders({ int page = 1, int limit = 100 });
}