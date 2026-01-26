import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/domain/datasources/recharge_datasource.dart';
import 'package:klicum/domain/entities/recharge_intent.dart';
import 'package:klicum/infraestructure/mappers/recharge_intent_mapper.dart';
import 'package:klicum/infraestructure/models/recharge_intent_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RechargeDatasourceImpl implements RechargeDatasource {
  final baseUrl = '${Enviroment.baseURL}/recharge';

  @override
  Future<RechargeIntent> createIntent({required int amount}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse('$baseUrl/create-intent');

    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "amount": amount
      })
    );
    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en createIntent');

    final json = jsonDecode(response.body);

    if (response.statusCode != 201) throw Exception(Helper.extractErrorMessage(json, 'Algo sucedio mal, intentalo mas tarde'));

    final rechargeIntentResponse = RechargeIntentResponse.fromJson(json);

    return RechargeIntentMapper.rechargeIntentResponseToEntity(rechargeIntentResponse);
  }

}