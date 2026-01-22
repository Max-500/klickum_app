import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/product_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/product_repository_impl.dart';
import 'package:klicum/presentation/providers/auth_provider.dart';

final productRepositoryProvider = Provider((ref) => ProductRepositoryImpl(datasource: ProductDatasourceImpl(
  onUnauthorized: () => ref.read(authProvider.notifier).logout()
)));