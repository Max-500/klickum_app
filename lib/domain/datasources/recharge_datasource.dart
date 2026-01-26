import 'package:klicum/domain/entities/recharge_intent.dart';

abstract class RechargeDatasource {
  Future<RechargeIntent> createIntent({ required int amount });
}