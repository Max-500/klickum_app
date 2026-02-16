import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/cart_datasource.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/variant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDatasourceImpl implements CartDatasource {
  final Future<void> Function() onUnauthorized;
  final String baseURL = '${Enviroment.baseURL}/cart';

  CartDatasourceImpl({required this.onUnauthorized});
  
  @override
  Future<void> addVariant({required int productVariantID, int amount = 1}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final userID = prefs.getString('id');

    if (token == null || userID == null) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en addVariant');
    }

    final url = Uri.parse('$baseURL/add');

    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode([
        {
          "productVariantId": productVariantID,
          "amount": amount
        }
      ])
    );

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en addVariant');
    }
    
    if (response.statusCode != 201) throw Exception('Error al guardar el producto');
  }

  @override
  Future<Map<int, CartProduct>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    if (token == null) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getProducts');
    }

    final url = Uri.parse('$baseURL/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      } 
    );

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getProducts');
    }

    if (response.statusCode != 200) throw Exception('Error al cargar el carrito');

    final Map<int, CartProduct> cartMap = {};

    final json = jsonDecode(response.body);

    final items = json['items'] as List<dynamic>? ?? [];

    for (final raw in items) {
      try {
        final item = raw as Map<String, dynamic>;

        final pv = item['productVariant'] as Map<String, dynamic>;
        final productJson = pv['product'] as Map<String, dynamic>;
        final id = pv['id'] as int;

        final sizeLabel = (pv['size'] as Map<String, dynamic>?)?['label']?.toString() ?? '';

        final variant = Variant(
          id: id,
          sku: pv['sku']?.toString() ?? '',
          price: -1,
          amount: (pv['amount'] as num?)?.toInt() ?? 0,
          size: sizeLabel, // o SizeModel si aplica
          createdAt: DateTime.parse(pv['created_at'] as String),
          updatedAt: DateTime.parse(pv['updated_at'] as String),
        );

        final product = CartProduct(
          id: item['id'],
          name: productJson['name']?.toString() ?? '',
          amount: (item['amount'] as num?)?.toInt() ?? 0,
          variant: variant,
          price: double.tryParse(productJson['price']?.toString() ?? '') ?? -1,
        );

        cartMap[id] = product;
      } catch (_, _) {}
    }

    return cartMap;
  }
  
  @override
  Future<void> updateVariant({required int productVariantID, required int amount, required bool isIncrement}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final userID = prefs.getString('id');

    if (token == null || userID == null) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en addVariant');
    }

    final url = Uri.parse(baseURL);

    final response = await http.patch(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "productVariantId": productVariantID,
        "amount": isIncrement ? amount + 1 : amount - 1
      })
    );

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en addVariant');
    }
    
    if (response.statusCode != 200) throw Exception('Error al eliminar producto');
  }
  
  @override
  Future<void> deleteVariant({required String id}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final userID = prefs.getString('id');

    if (token == null || userID == null) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en addVariant');
    }

    final url = Uri.parse(baseURL);

    final response = await http.delete(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode([id])
    );

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en addVariant');
    }
    
    if (response.statusCode != 200) throw Exception('Error al eliminar producto');
  }

}