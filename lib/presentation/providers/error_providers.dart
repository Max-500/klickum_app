import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeErrorProvider = NotifierProvider<HomeErrorNotifier, Object?>(HomeErrorNotifier.new);
class HomeErrorNotifier extends Notifier<Object?> {
  @override
  Object? build() => null;

  void setError(Object error) => state = error;
  
  void clear() => state = null;
}

final raffleTicketsErrorProvider = NotifierProvider<RaffleTicketsHotifier, Object?>(RaffleTicketsHotifier.new);
class RaffleTicketsHotifier extends Notifier<Object?> {
  @override
  Object? build() => null;

  void setError(Object error) => state = error;
  
  void clear() => state = null;
}

final addressErrorProvider = NotifierProvider<AddressNotifier, Object?>(AddressNotifier.new);
class AddressNotifier extends Notifier<Object?> {
  @override
  Object? build() => null;

  void setError(Object error) => state = error;
  
  void clear() => state = null;
}