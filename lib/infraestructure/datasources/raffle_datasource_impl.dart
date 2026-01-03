import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/raffle_datasource.dart';
import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/infraestructure/mappers/raffle_mapper.dart';
import 'package:klicum/infraestructure/models/raffle_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaffleDatasourceImpl implements RaffleDatasource {
  final String baseURL = '${Enviroment.baseURL}/raffle';

  @override
  Future<RaffleData> getRaffles({int page = 1, int limit = 100}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse(baseURL).replace(queryParameters: {
      'page': 1.toString(),
      'limit': limit.toString()
    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en getRaffles');
    if (response.statusCode != 200) throw Exception('Error al obtener las rifas');

    final json = jsonDecode(response.body);

    final rafflesResponse = (json['items'] as List<dynamic>? ?? []).map((item) {
      try {
        return RaffleResponse.fromJson(item);
      } catch(e) {
        debugPrint(e.toString());
      }
    }).whereType<RaffleResponse>().toList();

    final raffles = rafflesResponse.map((raffleResponse) => RaffleMapper.raffleResponseToEntity(raffleResponse)).toList();

    return RaffleData(raffles: raffles, totalPages: json['meta']?['totalPages'] ?? 0);
  }

}