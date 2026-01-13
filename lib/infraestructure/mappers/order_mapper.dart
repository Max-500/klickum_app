import 'package:klicum/domain/entities/order.dart';
import 'package:klicum/infraestructure/mappers/address_mapper.dart';
import 'package:klicum/infraestructure/mappers/product_mapper.dart';
import 'package:klicum/infraestructure/models/order_response.dart';

class OrderMapper {
  static Order orderResponseToEntity(OrderResponse response) => Order(
    id: response.id, 
    isActive: response.isActive, 
    createdAt: response.createdAt, 
    updatedAt: response.updatedAt, 
    total: response.total, 
    isSent: response.isSent, 
    products: response.products.map((productResponse) => ProductMapper.productResponseToEntity(productResponse)).toList(), 
    address: AddressMapper.addressResponseToEntity(response.address), 
    status: response.status
  );
}