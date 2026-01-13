import 'package:klicum/domain/entities/presentation/my_raffle_data.dart';
import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/domain/entities/ticket.dart';

abstract class RaffleRepository {
  Future<RaffleData> getRaffles({ int page = 1, int limit = 100 });
  Future<Map<String, Ticket>> getRafflesTickets({ required String id });
  Future<Ticket> buyTicket({ required String id, required String code });
  Future<MyRaffleData> getRafflesByUser({ int page = 1, int limit = 100 });
}