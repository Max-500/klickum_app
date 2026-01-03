import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/entities/presentation/product_data.dart';
import 'package:klicum/domain/entities/product.dart';
import 'package:klicum/presentation/providers/repositories/product_repository_provider.dart';

final productProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(ProductsNotifier.new);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  int currentPage = 1;
  int totalPages = 0;

  bool isLoadingMore = false;

  @override
  Future<List<Product>> build() async {
    final data = await fetchProducts(page: 1);

    currentPage = 2;
    totalPages = data.totalPages;


    return data.products;
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore) return;
    if (currentPage > totalPages && totalPages != 0) return;

    isLoadingMore = true;

    try {
      final data = await fetchProducts(page: currentPage);
      ref.read(loadMoreProductsErrorProvider.notifier).clear();
      currentPage++;
      totalPages = data.totalPages;

      final previous = state.value ?? const <Product>[];
      state = AsyncData([...previous, ...data.products]);
    } catch (e, st) {
      ref.read(loadMoreProductsErrorProvider.notifier).setError(e);
      if (state.hasValue && (state.value?.isNotEmpty ?? false) && e is! SessionExpiredException) return;
    
      state = AsyncError(e, st);
    } finally {
      isLoadingMore = false;
    }
  }

  Future<ProductData> fetchProducts({required int page}) {
    return ref.read(productRepositoryProvider).getProducts(
      page: page,
      limit: 100,
      query: '',
      isPromoted: false,
      category: '',
    );
  }
}

final loadMoreProductsErrorProvider =NotifierProvider<LoadMoreProductsErrorNotifier, Object?>(LoadMoreProductsErrorNotifier.new);
class LoadMoreProductsErrorNotifier extends Notifier<Object?> {
  @override
  Object? build() => null;

  void setError(Object error) {
    state = error;
  }

  void clear() {
    state = null;
  }
}