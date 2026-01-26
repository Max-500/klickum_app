import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/entities/order.dart';
import 'package:klicum/domain/entities/presentation/order_data.dart';
import 'package:klicum/presentation/providers/repositories/order_repository_provider.dart';

final orderProvider = AsyncNotifierProvider<OrderNotifier, List<Order>>(OrderNotifier.new);
class OrderNotifier extends AsyncNotifier<List<Order>> {
  int currentPage = 1;
  int totalPages = 0;

  bool isLoadingMore = false;

  @override
  FutureOr<List<Order>> build() async {
    final data = await fetchOrders(page: 1);

    currentPage = 2;
    totalPages = data.totalPages;

    return data.orders;
  }

  Future<void> loadMoreOrders() async {
    if (isLoadingMore) return;
    if (currentPage > totalPages && totalPages != 0) return;

    isLoadingMore = true;

    try {
      final data = await fetchOrders(page: currentPage);
      //ref.read(loadMoreProductsErrorProvider.notifier).clear();
      currentPage++;
      totalPages = data.totalPages;

      final previous = state.value ?? const <Order>[];
      state = AsyncData([...previous, ...data.orders]);
    } catch (e, st) {
      //ref.read(loadMoreProductsErrorProvider.notifier).setError(e);
      if (state.hasValue && (state.value?.isNotEmpty ?? false) && e is! SessionExpiredException) return;
    
      state = AsyncError(e, st);
    } finally {
      isLoadingMore = false;
    }
  }


  Future<OrderData> fetchOrders({required int page}) async => await ref.read(orderRepositoryProvider).getOrders(page: page);
}