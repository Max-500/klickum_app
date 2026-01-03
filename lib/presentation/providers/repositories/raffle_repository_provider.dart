import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/raffle_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/raffle_repository_impl.dart';

final raffleRepositoryProvider = Provider((ref) => RaffleRepositoryImpl(datasource: RaffleDatasourceImpl()));