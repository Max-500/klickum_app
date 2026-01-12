import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/product_datasource.dart';
import 'package:klicum/domain/entities/presentation/product_data.dart';
import 'package:klicum/infraestructure/mappers/product_mapper.dart';
import 'package:klicum/infraestructure/models/product_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDatasourceImpl implements ProductDatasource {
  final String baseURL = '${Enviroment.baseURL}/v2/product';

  @override
  Future<ProductData> getProducts({int page = 1, int limit = 100, String query = '', bool isPromoted = false, String category = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse(baseURL).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
      'query': '',
      'promoted': '',
      'category': '',
    });

    final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en getProducts');
    if (response.statusCode == 429) throw TooManyRequestException(message: 'PENDING');
    if (response.statusCode != 200) throw Exception('Error al obtener los productos');

    final json = jsonDecode(response.body);
    final productsResponse = (json['items'] as List<dynamic>? ?? []).map((item) {
      try {
        return ProductResponse.fromJson(item);
      } catch(error) {
        debugPrint(error.toString());
      }
    }).whereType<ProductResponse>().toList();

    final products = productsResponse.map((productResponse) => ProductMapper.productResponseToEntity(productResponse)).toList();
    return ProductData(products: products, totalPages: json['meta']?['totalPages'] ?? 0);
  }
}