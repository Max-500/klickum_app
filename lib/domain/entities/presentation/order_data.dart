import 'package:klicum/domain/entities/order.dart';

class OrderData {
  final int totalPages;
  final List<Order> orders;

  OrderData({required this.totalPages, required this.orders});
}