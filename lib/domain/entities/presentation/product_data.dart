import 'package:klicum/domain/entities/product.dart';

class ProductData {
  final List<Product> products;
  final int totalPages;

  ProductData({required this.products, required this.totalPages});
}