import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/order_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/order_repository_impl.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepositoryImpl(datasource: OrderDatasourceImpl()));