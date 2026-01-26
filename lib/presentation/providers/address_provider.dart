import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/entities/address.dart';
import 'package:klicum/domain/entities/country.dart';
import 'package:klicum/domain/entities/presentation/address_data.dart';
import 'package:klicum/domain/entities/presentation/countries_data.dart';
import 'package:klicum/presentation/providers/error_providers.dart';
import 'package:klicum/presentation/providers/repositories/address_repository_provider.dart';

final countriesProvider = AsyncNotifierProvider<CountriesNotifier, List<Country>>(CountriesNotifier.new);

class CountriesNotifier extends AsyncNotifier<List<Country>> {
  final List<Country> _all = <Country>[];
  String _query = '';

  @override
  FutureOr<List<Country>> build() async {
    _all.clear();

    final first = await _fetch(page: 1);
    _all.addAll(first.countries);

    final totalPages = first.totalPages;
    for (int page = 2; page <= totalPages; page++) {
      final data = await _fetch(page: page);
      _all.addAll(data.countries);
    }

    return _applyFilter(_all, _query);
  }

  Future<void> setSearchQuery(String value) async {
    _query = value.trim();
    state = AsyncData(_applyFilter(_all, _query));
  }

  Future<CountriesData> _fetch({required int page}) => ref.read(addressRepositoryProvider).getCountries(page: page);
  

  List<Country> _applyFilter(List<Country> source, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [...source];

    return source
        .where((c) => c.name.toLowerCase().contains(q))
        .toList(growable: false);
  }
}

final addressProvider = AsyncNotifierProvider.autoDispose<AddressNotifier, List<Address>>(AddressNotifier.new);
class AddressNotifier extends AsyncNotifier<List<Address>> {
  int currentPage = 1;
  int totalPages = 0;

  bool isLoadingMore = false;
  bool isFirstError = true;
  
  @override
  FutureOr<List<Address>> build() async {
    try {
      final data = await fetchAddress(1);
      
      currentPage = 2;
      totalPages = data.totalPages;
      
      return data.address;
    } catch (e, st) {
      if (isFirstError) ref.read(addressErrorProvider.notifier).setError(e);
      isFirstError = false;
      if (e is SessionExpiredException) return const <Address>[];
    
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> loadMoreAddress() async {
    if (isLoadingMore) return;
    if (currentPage > totalPages && totalPages != 0) return;
    isLoadingMore = true;

    try {
      final data = await fetchAddress(currentPage);
      ref.read(addressErrorProvider.notifier).clear();
      currentPage++;
      totalPages = data.totalPages;

      final previous = state.value ?? const <Address>[];
      state = AsyncData([...previous, ...data.address]);
    } catch (e, st) {
      if (isFirstError) ref.read(addressErrorProvider.notifier).setError(e);
      isFirstError = false;
      if (state.hasValue && (state.value?.isNotEmpty ?? false) && e is! SessionExpiredException) return;
    
      state = AsyncError(e, st);
    } finally {
      isLoadingMore = false;
    }
  }

  void addAddress(Address address) {
    final current = state.asData?.value;

    if (current == null) {
      ref.invalidateSelf();
      return;
    }

    final withoutDup = current.where((a) => a.id != address.id).toList();

    state = AsyncData([address, ...withoutDup]);
  }

  Future<AddressData> fetchAddress(int page) async => await ref.read(addressRepositoryProvider).getAddress(page: page);
}