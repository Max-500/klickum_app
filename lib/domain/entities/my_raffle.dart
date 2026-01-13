import 'package:klicum/domain/entities/raffle.dart';

class MyRaffle {
  final String id;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Raffle raffle;
  final String code;

  MyRaffle({required this.id, required this.isActive, required this.createdAt, required this.updatedAt, required this.raffle, required this.code});
}