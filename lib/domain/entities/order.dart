import 'package:klicum/config/constants/types.dart';
import 'package:klicum/domain/entities/address.dart';
import 'package:klicum/domain/entities/product.dart';

class Order {
  final String id;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double total;
  final bool isSent;
  final List<Product> products;
  final Address address;
  final OrderStatus status;

  Order({required this.id, required this.isActive, required this.createdAt, required this.updatedAt, required this.total, required this.isSent, required this.products, required this.address, required this.status});
}