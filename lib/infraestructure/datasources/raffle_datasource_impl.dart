import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/raffle_datasource.dart';
import 'package:klicum/domain/entities/presentation/my_raffle_data.dart';
import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/domain/entities/ticket.dart';
import 'package:klicum/infraestructure/mappers/my_raffle_mapper.dart';
import 'package:klicum/infraestructure/mappers/raffle_mapper.dart';
import 'package:klicum/infraestructure/mappers/ticket_mapper.dart';
import 'package:klicum/infraestructure/models/my_raffle_response.dart';
import 'package:klicum/infraestructure/models/raffle_response.dart';
import 'package:klicum/infraestructure/models/ticket_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaffleDatasourceImpl implements RaffleDatasource {
  final Future<void> Function() onUnauthorized;
  final String baseURL = '${Enviroment.baseURL}/raffle';

  RaffleDatasourceImpl({required this.onUnauthorized});

  @override
  Future<RaffleData> getRaffles({int page = 1, int limit = 100}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
  
    if (token == null) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getRaffles');
    }

    final url = Uri.parse(baseURL).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString()
    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getRaffles');
    }
    
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

  @override
  Future<Map<String, Ticket>> getRafflesTickets({required String id}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final userID = prefs.getString('id');

    if (token == null || userID == null) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getRafflesTickets');
    }

    final url = Uri.parse('$baseURL/$id');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getRaffles');
    }
    if (response.statusCode != 200) throw Exception('Error al obtener los tickets');

    final json = jsonDecode(response.body);

    final ticketsResponse = (json['tickets'] as List<dynamic>? ?? []).map((item) => TicketResponse.fromJson(item, userID)).toList();
    final Map<String, Ticket> data = {};

    for (final ticketResponse in ticketsResponse) {
      final ticket = TicketMapper.ticketResponseToEntity(ticketResponse);
      data[ticket.code] = ticket;
    }
    return data;
  }
  
  @override
  Future<Ticket> buyTicket({required String id, required String code}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final userID = prefs.getString('id');

    if (token == null || userID == null) throw SessionExpiredException(message: 'Sesión Terminada en buyTicket');

    final url = Uri.parse('${Enviroment.baseURL}/ticket');

    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }, 
      body: jsonEncode({
        'raffleId': id,
        'code': int.parse(code)
      }));

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en buyTicket');
    if (response.statusCode != 201) throw Exception('Error al comprar el ticket, intentalo mas tarde');

    final json = jsonDecode(response.body);

    final ticketResponse = TicketResponse.fromJson(json, userID);

    return TicketMapper.ticketResponseToEntity(ticketResponse);
  }

  @override
  Future<MyRaffleData> getRafflesByUser({int page = 1, int limit = 100}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse('${Enviroment.baseURL}/ticket/history').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString()
    });

    final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en getRafflesByUser');
    if (response.statusCode != 200) throw Exception('Error al obtener los tickets, intentalo mas tarde');

    final json = jsonDecode(response.body);

    final myRafflesResponse = (json['items'] as List<dynamic>? ?? []).map((item) => MyRaffleResponse.fromJson(item)).toList();

    final myRaffles = myRafflesResponse.map((myRaffleResponse) => MyRaffleMapper.myRaffleResponseToEntity(myRaffleResponse)).toList();
    
    return MyRaffleData(totalPages: json['meta']['totalPages'], myRaffles: myRaffles);
  }

}