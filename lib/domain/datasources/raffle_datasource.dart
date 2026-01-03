import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/domain/entities/ticket.dart';

abstract class RaffleDatasource {
  Future<RaffleData> getRaffles({ int page = 1, int limit = 100 });
  Future<Map<String, Ticket>> getRafflesTickets({ required String id });
  Future<Ticket> buyTicket({ required String id, required String code });
}