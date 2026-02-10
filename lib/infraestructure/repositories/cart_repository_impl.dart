import 'package:klicum/domain/datasources/cart_datasource.dart';
import 'package:klicum/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDatasource datasource;

  CartRepositoryImpl({required this.datasource});
  
  @override
  Future<void> addVariant({required int productVariantID, int amount = 1}) async => await datasource.addVariant(productVariantID: productVariantID, amount: amount);
}