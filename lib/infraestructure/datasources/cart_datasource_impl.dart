import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/cart_datasource.dart';
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

}