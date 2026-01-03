import 'package:klicum/domain/datasources/raffle_datasource.dart';
import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/domain/repositories/raffle_repository.dart';

class RaffleRepositoryImpl implements RaffleRepository {
  final RaffleDatasource datasource;

  RaffleRepositoryImpl({required this.datasource});

  @override
  Future<RaffleData> getRaffles({int page = 1, int limit = 100}) async => await datasource.getRaffles(page: page, limit: limit);
}