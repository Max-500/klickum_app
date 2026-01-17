import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/recharge_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/recharge_respository_impl.dart';

final rechargeRepositoryProvider = Provider((ref) => RechargeRespositoryImpl(datasource: RechargeDatasourceImpl()));