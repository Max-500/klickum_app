import 'package:flutter/material.dart';

enum ProductGroup { simple, variable }
extension ProductGroupExtension on ProductGroup {
  static ProductGroup fromString(String value) {
    switch (value.toLowerCase()) {
      case 'simple':
        return ProductGroup.simple;
      case 'variable':
        return ProductGroup.variable;
      default:
        throw Exception('Error: Unkown product group');
    }
  }
}

enum ProductStatus { available, outOfStock, discontinued }
extension ProductStatusExtension on ProductStatus {
  static ProductStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'available':
        return ProductStatus.available;
      case 'outofstock':
        return ProductStatus.outOfStock;
      case 'discontinued':
        return ProductStatus.discontinued;
      default:
        throw Exception('Error: Unkown product status');
    }
  }
}

enum ProductType { physical, digital }
extension ProductTypeExtension on ProductType {
  static ProductType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'physical':
        return ProductType.physical;
      case 'digital':
        return ProductType.digital;
      default:
        throw Exception('Error Unkown product type');
    }
  }
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
  completed,
  onHold,
}
extension OrderStatusExtension on OrderStatus {
  /// Convierte string API -> enum
  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'refunded':
        return OrderStatus.refunded;
      case 'completed':
        return OrderStatus.completed;
      case 'onhold':
        return OrderStatus.onHold;
      default:
        throw Exception('Error Unknown order status: $value');
    }
  }

  String get labelEs {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.processing:
        return 'En proceso';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
      case OrderStatus.refunded:
        return 'Reembolsado';
      case OrderStatus.completed:
        return 'Completado';
      case OrderStatus.onHold:
        return 'En espera';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.greenAccent;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.refunded:
        return Colors.purple;
      case OrderStatus.onHold:
        return Colors.amber;
    }
  }
}
