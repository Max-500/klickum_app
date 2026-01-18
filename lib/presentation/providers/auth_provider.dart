import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/config/constants/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.authenticated;

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = AuthStatus.unauthenticated;
  }

  Future<void> markAuthenticated() async {
    state = AuthStatus.authenticated;
  }
}