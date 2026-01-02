import 'package:klicum/domain/datasources/product_datasource.dart';
import 'package:klicum/domain/entities/presentation/product_data.dart';
import 'package:klicum/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource datasource;

  ProductRepositoryImpl({required this.datasource});

  @override
  Future<ProductData> getProducts({int page = 1, int limit = 100, String query = '', bool isPromoted = false, String category = ''}) async => await datasource.getProducts(page: page, limit: limit, category: category, isPromoted: isPromoted, query: query);
}