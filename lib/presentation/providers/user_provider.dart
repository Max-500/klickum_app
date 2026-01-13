import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/domain/entities/user_auth.dart';
import 'package:klicum/presentation/providers/repositories/auth_repository_provider.dart';

final meProvider = AsyncNotifierProvider<UserNotifier, UserAuth>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<UserAuth> {

  @override
  FutureOr<UserAuth> build() async => await fetchUserAuth();
  
  Future<UserAuth> fetchUserAuth() async => await ref.read(authRepositoryProvider).getMe();
}