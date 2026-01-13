import 'package:klicum/domain/entities/user_auth.dart';
import 'package:klicum/infraestructure/models/user_auth_response.dart';

class UserAuthMapper {
  static UserAuth userAuthResponseToEntity(UserAuthResponse response) => UserAuth(
    id: response.id, 
    username: response.username, 
    phone: response.phone, 
    email: response.email, 
    balance: response.balance, 
    isActive: response.isActive
  );
}