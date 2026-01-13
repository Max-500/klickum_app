import 'package:klicum/infraestructure/models/raffle_response.dart';

class MyRaffleResponse {
  final String id;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RaffleResponse raffleResponse;
  final String code;

  MyRaffleResponse({required this.id, required this.isActive, required this.createdAt, required this.updatedAt, required this.raffleResponse, required this.code});

  factory MyRaffleResponse.fromJson(Map<String, dynamic> json) => MyRaffleResponse(
    id: json['id'], 
    isActive: json['isActive'], 
    createdAt: DateTime.parse(json['created_at']), 
    updatedAt: DateTime.parse(json['updated_at']), 
    raffleResponse: RaffleResponse.fromJson(json['raffle']), 
    code: json['code'].toString()
  );
}