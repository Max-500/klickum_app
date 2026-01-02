import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/auth_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(datasource: AuthDatasourceImpl()));