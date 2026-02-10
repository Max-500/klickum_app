import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/cart_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/cart_repository_impl.dart';
import 'package:klicum/presentation/providers/auth_provider.dart';

final cartRepositoryProvider = Provider(
  (ref) => CartRepositoryImpl(datasource: CartDatasourceImpl(onUnauthorized: () => ref.read(authProvider.notifier).logout()))
);