import 'package:klicum/domain/entities/user_auth.dart';

abstract class AuthRepository {
  Future<void> signUp({ required String username, required String email, required String phone, required String password });
  Future<void> signIn({ required String username, required String password });
  Future<UserAuth> getMe();
  Future<void> changePassword({ required String currentPassword, required String newPassword });
}