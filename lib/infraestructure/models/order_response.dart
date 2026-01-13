import 'package:klicum/config/constants/types.dart';
import 'package:klicum/infraestructure/models/address_response.dart';
import 'package:klicum/infraestructure/models/product_response.dart';

class OrderResponse {
  final String id;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double total;
  final bool isSent;
  final List<ProductResponse> products;
  final AddressResponse address;
  final OrderStatus status;

  OrderResponse({required this.id, required this.isActive, required this.createdAt, required this.updatedAt, required this.total, required this.isSent, required this.products, required this.address, required this.status});

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    id: json['id'], 
    isActive: json['isActive'], 
    createdAt: DateTime.parse(json['created_at']), 
    updatedAt: DateTime.parse(json['updated_at']), 
    total: double.tryParse(json['totalPrice']) ?? -1, 
    isSent: json['isSent'], 
    products: (json['items'] as List<dynamic>? ?? []).map((item) => ProductResponse.fromOrderJson(item)).toList(), 
    address: AddressResponse.fromOrderJson(json['address']), 
    status: OrderStatusExtension.fromString(json['status']['name'])
  );
}