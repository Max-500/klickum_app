import 'package:klicum/domain/datasources/auth_datasource.dart';
import 'package:klicum/domain/entities/user_auth.dart';
import 'package:klicum/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<void> signUp({required String username, required String email, required String phone, required String password}) async => await datasource.signUp(username: username, email: email, phone: phone, password: password);
  
  @override
  Future<void> signIn({required String username, required String password}) async => datasource.signIn(username: username, password: password);

  @override
  Future<UserAuth> getMe() async => await datasource.getMe();

}