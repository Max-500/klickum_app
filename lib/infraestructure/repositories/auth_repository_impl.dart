import 'package:klicum/domain/datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthDatasource {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<void> signUp({required String username, required String email, required String phone, required String password}) async => await datasource.signUp(username: username, email: email, phone: phone, password: password);
  
  @override
  Future<void> signIn({required String username, required String password}) async => datasource.signIn(username: username, password: password);

}