import 'package:klicum/domain/entities/ticket.dart';
import 'package:klicum/infraestructure/models/ticket_response.dart';

class TicketMapper {
  static Ticket ticketResponseToEntity(TicketResponse response) => Ticket(id: response.id, isActive: response.isActive, code: response.code, isMyTicket: response.isMyTikcet);
}