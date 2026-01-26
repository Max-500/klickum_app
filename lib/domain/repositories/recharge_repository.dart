import 'package:klicum/domain/entities/recharge_intent.dart';

abstract class RechargeRepository {
  Future<RechargeIntent> createIntent({ required int amount });
}