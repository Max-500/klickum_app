import 'package:klicum/domain/datasources/order_datasource.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/presentation/order_data.dart';
import 'package:klicum/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDatasource datasource;

  OrderRepositoryImpl({required this.datasource});

  @override
  Future<void> createOrder({required Map<int, CartProduct> variants, required String addressID}) async => await datasource.createOrder(variants: variants, addressID: addressID);

  @override
  Future<OrderData> getOrders({int page = 1, int limit = 100}) async => await datasource.getOrders(page: page, limit: limit);
}