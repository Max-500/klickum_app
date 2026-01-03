import 'package:klicum/domain/entities/raffle.dart';

class RaffleData {
  final List<Raffle> raffles;
  final int totalPages;

  RaffleData({required this.raffles, required this.totalPages});
}