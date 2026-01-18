import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/domain/repositories/raffle_repository.dart';
import 'package:klicum/infraestructure/datasources/raffle_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/raffle_repository_impl.dart';
import 'package:klicum/presentation/providers/auth_provider.dart';

final raffleRepositoryProvider = Provider<RaffleRepository>(
  (ref) => RaffleRepositoryImpl(datasource: RaffleDatasourceImpl(onUnauthorized: () => ref.read(authProvider.notifier).logout()))
);