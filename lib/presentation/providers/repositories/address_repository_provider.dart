import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/address_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/address_repository_impl.dart';

final addressRepositoryProvider = Provider((ref) => AddressRepositoryImpl(datasource: AddressDatasourceImpl()));