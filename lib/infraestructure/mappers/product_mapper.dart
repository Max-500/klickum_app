import 'package:klicum/domain/entities/product.dart';
import 'package:klicum/infraestructure/mappers/category_mapper.dart';
import 'package:klicum/infraestructure/mappers/variant_mapper.dart';
import 'package:klicum/infraestructure/models/product_response.dart';

class ProductMapper {
  static Product productResponseToEntity(ProductResponse response) => Product(
    id: response.id, 
    name: response.name, 
    description: response.description, 
    amount: response.amount, 
    price: response.price, 
    isPromoted: response.isPromoted, 
    isActive: response.isActive,
    image: response.image, 
    productGroup: response.productGroup, 
    productType: response.productType, 
    productStatus: response.productStatus, 
    category: CategoryMapper.categoryResponseToEntity(response.category), 
    variants: response.variants.map((e) => VariantMapper.variantResponseToEntity(e)).toList(), 
    createdAt: response.createdAt, 
    updatedAt: response.updatedAt
  );
}