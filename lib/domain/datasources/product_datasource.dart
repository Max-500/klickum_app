import 'package:klicum/domain/entities/presentation/product_data.dart';

abstract class ProductDatasource {
  Future<ProductData> getProducts({ int page = 1, int limit = 100, String query = '', bool isPromoted = false, String category = '' });
}