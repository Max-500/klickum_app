abstract class AuthRepository {
  Future<void> signUp({ required String username, required String email, required String phone, required String password });
  Future<void> signIn({ required String username, required String password });
}