import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/address_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/address_repository_impl.dart';
import 'package:klicum/presentation/providers/auth_provider.dart';

final addressRepositoryProvider = Provider(
  (ref) => AddressRepositoryImpl(datasource: AddressDatasourceImpl(onUnauthorized: () => ref.read(authProvider.notifier).logout()))
);