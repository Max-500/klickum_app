abstract class CartRepository {
  Future<void> addVariant({ required int productVariantID, int amount = 1 });
}