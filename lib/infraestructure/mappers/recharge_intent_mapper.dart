import 'package:klicum/domain/entities/recharge_intent.dart';
import 'package:klicum/infraestructure/models/recharge_intent_response.dart';

class RechargeIntentMapper {
  static RechargeIntent rechargeIntentResponseToEntity(RechargeIntentResponse response) => RechargeIntent(
    id: response.id, 
    amount: response.amount, 
    serviceFee: response.serviceFee, 
    total: response.total, 
    clientSecret: response.clientSecret, 
    status: response.status, 
    createdAt: response.createdAt
  );
}