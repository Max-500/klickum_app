import 'package:klicum/domain/entities/presentation/cart_product.dart';

abstract class CartDatasource {
  Future<void> addVariant({ required int productVariantID, int amount = 1 });
  Future<Map<int, CartProduct>> getProducts();
  Future<void> updateVariant({required int productVariantID, required int amount, required bool isIncrement});
  Future<void> deleteVariant({required String id});
}