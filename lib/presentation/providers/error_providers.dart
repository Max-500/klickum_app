import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeErrorProvider = NotifierProvider<LoadMoreProductsErrorNotifier, Object?>(LoadMoreProductsErrorNotifier.new);
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