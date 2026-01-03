import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/infraestructure/models/raffle_response.dart';

class RaffleMapper {
  static Raffle raffleResponseToEntity(RaffleResponse response) => Raffle(
    id: response.id, 
    reward: response.reward, 
    price: response.price, 
    amount: response.amount, 
    isActive: response.isActive, 
    createdAt: response.createdAt, 
    updatedAt: response.updatedAt
  );
}