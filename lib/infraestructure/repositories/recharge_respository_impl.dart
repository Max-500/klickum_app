import 'package:klicum/domain/datasources/recharge_datasource.dart';
import 'package:klicum/domain/entities/recharge_intent.dart';
import 'package:klicum/domain/repositories/recharge_repository.dart';

class RechargeRespositoryImpl implements RechargeRepository {
  final RechargeDatasource datasource;

  RechargeRespositoryImpl({required this.datasource});

  @override
  Future<RechargeIntent> createIntent({required double amount}) async => await datasource.createIntent(amount: amount);

}