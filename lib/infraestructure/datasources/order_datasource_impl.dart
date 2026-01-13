import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/order_datasource.dart';
import 'package:klicum/domain/entities/presentation/cart_product.dart';
import 'package:klicum/domain/entities/presentation/order_data.dart';
import 'package:klicum/infraestructure/mappers/order_mapper.dart';
import 'package:klicum/infraestructure/models/order_response.dart';
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

  @override
  Future<OrderData> getOrders({int page = 1, int limit = 100}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse('$baseUrl/history').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString()
    });


    final response = await http.get(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en getOrders');
    if (response.statusCode != 200) throw Exception('Error al obtener las ordenes');

    final json = jsonDecode(response.body);

    final ordersResponse = (json['items'] as List<dynamic>? ?? []).map((item) => OrderResponse.fromJson(item)).toList();

    final orders = ordersResponse.map((orderResponse) => OrderMapper.orderResponseToEntity(orderResponse)).toList();
    
    return OrderData(totalPages: json['meta']['totalPages'], orders: orders);
  }

}