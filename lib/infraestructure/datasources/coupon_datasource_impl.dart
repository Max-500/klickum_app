import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/coupon_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponDatasourceImpl implements CouponDatasource {
  final baseUrl = '${Enviroment.baseURL}/coupon';

  @override
  Future<void> useCoupon({required String coupon}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/use');

    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'code': coupon})
    );

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en useCoupon');
    if (response.statusCode != 201) throw Exception('Error al canjear el cupon, intentalo mas tarde');
  }

}