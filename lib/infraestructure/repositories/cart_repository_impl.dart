import 'package:klicum/domain/datasources/cart_datasource.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDatasource datasource;

  CartRepositoryImpl({required this.datasource});
  
  @override
  Future<void> addVariant({required int productVariantID, int amount = 1}) async => await datasource.addVariant(productVariantID: productVariantID, amount: amount);

  @override
  Future<Map<int, CartProduct>> getProducts() async => await datasource.getProducts();
  
  @override
  Future<void> updateVariant({required int productVariantID, required int amount, required bool isIncrement}) async => await datasource.updateVariant(productVariantID: productVariantID, amount: amount, isIncrement: isIncrement);
  
  @override
  Future<void> deleteVariant({required String id}) async => await datasource.deleteVariant(id: id);
}