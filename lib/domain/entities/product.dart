import 'package:klicum/config/constants/types.dart';
import 'package:klicum/domain/entities/category.dart';
import 'package:klicum/domain/entities/variant.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final int amount;
  final double price;
  final bool isPromoted;
  final bool isActive;
  final String image;

  final ProductGroup productGroup;
  final ProductType productType;
  final ProductStatus productStatus;

  final Category category;
  final List<Variant> variants;

  final DateTime createdAt;
  final DateTime updatedAt;

  Product({required this.id, required this.name, required this.description, required this.amount, required this.price, required this.isPromoted, required this.image, required this.productGroup, required this.productType, required this.productStatus, required this.category, required this.variants, required this.createdAt, required this.updatedAt, required this.isActive});
}