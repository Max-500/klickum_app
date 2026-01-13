import 'package:klicum/config/constants/types.dart';
import 'package:klicum/infraestructure/models/category_response.dart';
import 'package:klicum/infraestructure/models/variant_response.dart';

class ProductResponse {
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

  final CategoryResponse category;
  final List<VariantResponse> variants;

  final DateTime createdAt;
  final DateTime updatedAt;

  ProductResponse({required this.id, required this.name, required this.description, required this.amount, required this.price, required this.isPromoted, required this.image, required this.productGroup, required this.productType, required this.productStatus, required this.category, required this.variants, required this.createdAt, required this.updatedAt, required this.isActive});

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    amount: int.tryParse((json['amount'] ?? '').toString()) ?? -1,
    price: double.tryParse((json['price'] ?? '').toString()) ?? -1,
    isPromoted: json['promoted'],
    isActive: json['isActive'],

    image: (json['images'] is List && (json['images'] as List).isNotEmpty) ? (json['images'][0]['url']) ?? 'no-image' : 'no-image',

    productGroup: ProductGroupExtension.fromString(json['group']),
    productType: ProductTypeExtension.fromString(json['metadata']['productType']),
    productStatus: ProductStatusExtension.fromString(json['status']['name']),

    category: CategoryResponse.fromJson((json['category'])),
    variants: (json['variants'] is List)
      ? (json['variants'] as List).map((e) => VariantResponse.fromJson(e)).toList()
      : [],

    createdAt: DateTime.tryParse((json['created_at'])) ?? DateTime.now(),
    updatedAt: DateTime.tryParse((json['updated_at'])) ?? DateTime.now(),
  );

  factory ProductResponse.fromOrderJson(Map<String, dynamic> json) {
    final VariantResponse variantResponse = VariantResponse.fromJson(json['productVariant']);

    return ProductResponse(
      id: json['productVariant']['product']['id'],
      name: json['productVariant']['product']['name'],
      description: json['productVariant']['product']['description'],
      amount: int.tryParse((json['amount'] ?? '').toString()) ?? -1,
      price: double.tryParse((json['productVariant']['product']['price'] ?? '').toString()) ?? -1,
      isPromoted: json['productVariant']['product']['promoted'],
      isActive: json['productVariant']['product']['isActive'],

      image: '',

      productGroup: ProductGroupExtension.fromString(json['productVariant']['product']['group']),
      productType: ProductTypeExtension.fromString(json['productVariant']['product']['metadata']['productType']),
      productStatus: ProductStatusExtension.fromString(json['productVariant']['product']['status']['name']),

      category: CategoryResponse.fromJson((json['productVariant']['product']['category'])),
      variants: [variantResponse],

      createdAt: DateTime.tryParse((json['productVariant']['product']['created_at'])) ?? DateTime.now(),
      updatedAt: DateTime.tryParse((json['productVariant']['product']['updated_at'])) ?? DateTime.now(),
    );
  }
}