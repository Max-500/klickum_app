import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/order_datasource.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDatasourceImpl implements OrderDatasource {
  final baseUrl = '${Enviroment.baseURL}/order';

  @override
  Future<void> createOrder({required Map<int, CartProduct> variants, required String addressID}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'addressId': addressID,
        'items': variants.values.map((cp) => cp.toJson()).toList()
      })
    );

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en createOrder');
    if (response.statusCode != 201) throw Exception('Error al crear la orden');
  }

}