import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/presentation/providers/products_provider.dart';
import 'package:klicum/presentation/providers/repositories/raffle_repository_provider.dart';

final raffleProvider = AsyncNotifierProvider<RaffleNotifier, List<Raffle>>(RaffleNotifier.new);

class RaffleNotifier extends AsyncNotifier<List<Raffle>> {
  int currentPage = 1;
  int totalPages = 0;

  bool isLoadingMore = false;

  @override
  FutureOr<List<Raffle>> build() async {
    final data = await fetchRaffles(page: 1);

    currentPage = 2;
    totalPages = data.totalPages;

    return data.raffles;
  }

  Future<void> loadMoreRaffles() async {
    if (isLoadingMore) return;
    if (currentPage > totalPages && totalPages != 0) return;

    isLoadingMore = true;

    try {
      final data = await fetchRaffles(page: currentPage);
      ref.read(loadMoreProductsErrorProvider.notifier).clear();
      currentPage++;
      totalPages = data.totalPages;

      final previous = state.value ?? const <Raffle>[];
      state = AsyncData([...previous, ...data.raffles]);
    } catch (e, st) {
      ref.read(loadMoreProductsErrorProvider.notifier).setError(e);
      if (state.hasValue && (state.value?.isNotEmpty ?? false) && e is! SessionExpiredException) return;
    
      state = AsyncError(e, st);
    } finally {
      isLoadingMore = false;
    }

  }

  Future<RaffleData> fetchRaffles({required int page}) async => ref.read(raffleRepositoryProvider).getRaffles(page: page);
}