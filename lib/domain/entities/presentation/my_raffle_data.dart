import 'package:klicum/domain/entities/my_raffle.dart';

class MyRaffleData {
  final int totalPages;
  final List<MyRaffle> myRaffles;

  MyRaffleData({required this.totalPages, required this.myRaffles});
}