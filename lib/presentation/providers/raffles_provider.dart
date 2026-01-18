import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/entities/my_raffle.dart';
import 'package:klicum/domain/entities/presentation/my_raffle_data.dart';
import 'package:klicum/domain/entities/presentation/raffle_data.dart';
import 'package:klicum/domain/entities/raffle.dart';
import 'package:klicum/domain/entities/ticket.dart';
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

      if (e is SessionExpiredException) return;
      if (state.hasValue && (state.value?.isNotEmpty ?? false)) return;
    
      state = AsyncError(e, st);
    } finally {
      isLoadingMore = false;
    }

  }

  Future<RaffleData> fetchRaffles({required int page}) async => ref.read(raffleRepositoryProvider).getRaffles(page: page);
}

final raffleTicketIDProvider = NotifierProvider<RaffleTicketNotifier, String>(RaffleTicketNotifier.new);
class RaffleTicketNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setRaffleID(String id) => state = id;
}

final raffleTicketsProvider = AsyncNotifierProvider.autoDispose<RaffleTicketsNotifier, Map<String, Ticket>>(RaffleTicketsNotifier.new);

class RaffleTicketsNotifier extends AsyncNotifier<Map<String, Ticket>> {

  @override
  FutureOr<Map<String, Ticket>> build() async {
    final id = ref.read(raffleTicketIDProvider.notifier).state;
    return await ref.read(raffleRepositoryProvider).getRafflesTickets(id: id);
  }

  void toggleSinglePossibleTicket(String key) {
    if (!state.hasValue) return;

    final current = state.value!;
    final updated = Map<String, Ticket>.from(current);

    final ticket = updated[key];
    final exists = ticket != null;
    final isMyTicket = ticket?.isMyTicket ?? false;
    final isAssigned = (ticket?.id ?? 'no-id') != 'no-id';

    // Si está asignado/vendido o es de otro -> no hacer nada
    if (isAssigned) return;
    if (exists && !isMyTicket) return;

    // Si ya era mi posible -> lo quito (toggle off)
    if (exists && isMyTicket) {
      updated.remove(key);
      state = AsyncData(updated);
      return;
    }

    // Si voy a seleccionar uno nuevo:
    // 1) borro cualquier otro "posible" mío (para que solo haya 1)
    final keysToRemove = <String>[];
    updated.forEach((k, t) {
      final isPossibleMine = t.isMyTicket && t.id == 'no-id';
      if (isPossibleMine) keysToRemove.add(k);
    });
    for (final k in keysToRemove) {
      updated.remove(k);
    }

    // 2) agrego el nuevo
    updated[key] = Ticket(
      code: key,
      isMyTicket: true,
      id: 'no-id',
      isActive: false,
    );

    state = AsyncData(updated);
  }

  Future<void> purchaseTicket({required String raffleId, required String code}) async {
    if (!state.hasValue) return;

    final current = state.value!;
    final updated = Map<String, Ticket>.from(current);

    try {
      final purchased = await ref.read(raffleRepositoryProvider).buyTicket(id: raffleId, code: code);

      // 2) Reflejar en el state
      // Quitamos cualquier posible previo (ya que se concretó la compra)
      updated.removeWhere((k, t) => t.isMyTicket && t.id == 'no-id');

      // Guardamos el comprado (con id real)
      updated[code] = purchased;
      if (!ref.mounted) return;
      state = AsyncData(updated);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

final myRafflesProvider = AsyncNotifierProvider<MyRafflesNotifier, List<MyRaffle>>(MyRafflesNotifier.new);

class MyRafflesNotifier extends AsyncNotifier<List<MyRaffle>> {
  int currentPage = 1;
  int totalPages = 0;

  bool isLoadingMore = false;

  @override
  FutureOr<List<MyRaffle>> build() async {
    final data = await fetchMyRaffles(page: 1);

    currentPage = 2;
    totalPages = data.totalPages;

    return data.myRaffles;
  }

  Future<void> loadMoreRaffles() async {
    if (isLoadingMore) return;
    if (currentPage > totalPages && totalPages != 0) return;

    isLoadingMore = true;

    try {
      final data = await fetchMyRaffles(page: currentPage);
      //TODO: loadErrorProvider
      //* ref.read(loadMoreProductsErrorProvider.notifier).clear();
      currentPage++;
      totalPages = data.totalPages;

      final previous = state.value ?? const <MyRaffle>[];
      state = AsyncData([...previous, ...data.myRaffles]);
    } catch (e, st) {
      //TODO: loadErrorProvider
      //ref.read(loadMoreProductsErrorProvider.notifier).setError(e);
      if (state.hasValue && (state.value?.isNotEmpty ?? false) && e is! SessionExpiredException) return;
    
      state = AsyncError(e, st);
    } finally {
      isLoadingMore = false;
    }

  }

  Future<MyRaffleData> fetchMyRaffles({required int page}) async => ref.read(raffleRepositoryProvider).getRafflesByUser(page: page);
}