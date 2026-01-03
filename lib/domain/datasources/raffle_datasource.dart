import 'package:klicum/domain/entities/presentation/raffle_data.dart';

abstract class RaffleDatasource {
  Future<RaffleData> getRaffles({ int page = 1, int limit = 100 });
}