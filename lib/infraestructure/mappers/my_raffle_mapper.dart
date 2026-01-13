import 'package:klicum/domain/entities/my_raffle.dart';
import 'package:klicum/infraestructure/mappers/raffle_mapper.dart';
import 'package:klicum/infraestructure/models/my_raffle_response.dart';

class MyRaffleMapper {
  static MyRaffle myRaffleResponseToEntity(MyRaffleResponse response) => MyRaffle(
    id: response.id, 
    isActive: response.isActive, 
    createdAt: response.createdAt, 
    updatedAt: response.updatedAt, 
    raffle: RaffleMapper.raffleResponseToEntity(response.raffleResponse), 
    code: response.code
  );
}