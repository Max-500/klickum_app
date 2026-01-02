enum ProductGroup { simple, variable }
extension ProductGroupExtension on ProductGroup {
  static ProductGroup fromString(String value) {
    switch (value.toLowerCase()) {
      case 'simple':
        return ProductGroup.simple;
      case 'variable':
        return ProductGroup.variable;
      default:
        throw Exception('Error: Unkown product group');
    }
  }
}

enum ProductStatus { available, outOfStock, discontinued }
extension ProductStatusExtension on ProductStatus {
  static ProductStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'available':
        return ProductStatus.available;
      case 'outofstock':
        return ProductStatus.outOfStock;
      case 'discontinued':
        return ProductStatus.discontinued;
      default:
        throw Exception('Error: Unkown product status');
    }
  }
}

enum ProductType { physical, digital }
extension ProductTypeExtension on ProductType {
  static ProductType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'physical':
        return ProductType.physical;
      case 'digital':
        return ProductType.digital;
      default:
        throw Exception('Error Unkown product type');
    }
  }
}