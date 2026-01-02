import 'package:klicum/domain/entities/variant.dart';
import 'package:klicum/infraestructure/models/variant_response.dart';

class VariantMapper {
  static Variant variantResponseToEntity(VariantResponse response) => Variant(
    id: response.id, 
    sku: response.sku, 
    price: response.price, 
    amount: response.amount, 
    size: response.size, 
    createdAt: response.createdAt, 
    updatedAt: response.updatedAt
  );
}