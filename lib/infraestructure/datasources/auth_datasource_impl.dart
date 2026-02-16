import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/domain/datasources/auth_datasource.dart';
import 'package:klicum/domain/entities/user_auth.dart';
import 'package:klicum/infraestructure/mappers/user_auth_mapper.dart';
import 'package:klicum/infraestructure/models/user_auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final Future<void> Function() onUnauthorized;
  final String baseURL = '${Enviroment.baseURL}/auth';

  AuthDatasourceImpl({required this.onUnauthorized});

  @override
  Future<void> signUp({required String username, required String email, required String phone, required String password}) async {
    final url = Uri.parse('$baseURL/signup');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password.trim()
      })
    );

    final json = jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) throw Exception(Helper.extractErrorMessage(json, 'Error al registrarse, intentalo mas tarde'));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', json['access_token']);
  }
  
  @override
  Future<void> signIn({required String username, required String password}) async {
    final url = Uri.parse('$baseURL/login');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(),
        'password': password.trim()
      })
    );
    
    final json = jsonDecode(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) throw Exception(Helper.extractErrorMessage(json, 'Error al registrarse, intentalo mas tarde'));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', json['access_token']);

    final url2 = Uri.parse('$baseURL/me');
    final response2 = await http.get(url2, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${json['access_token']}'});
    final json2 = jsonDecode(response2.body);

    if (response2.statusCode != 200) throw Exception(Helper.extractErrorMessage(json, 'Algo sucedio mal, intentalo mas tarde'));

    prefs.setString('id', json2['id']);
  }

  @override
  Future<UserAuth> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse('$baseURL/me');
    final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});
    final json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      await onUnauthorized();
      throw Exception(Helper.extractErrorMessage(json, 'Algo sucedio mal, intentalo mas tarde'));
    }

    final userAuthResponse = UserAuthResponse.fromJson(json);
    return UserAuthMapper.userAuthResponseToEntity(userAuthResponse);
  }
  
  @override
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? 'no-token';

    final url = Uri.parse('$baseURL/me/password');
    final response = await http.patch(
      url, 
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "password": newPassword
      })
    );
    
    final raw = utf8.decode(response.bodyBytes).trim();
    final json = raw.isNotEmpty ? jsonDecode(raw) : null;

    if (response.statusCode != 200) {
      await onUnauthorized();
      throw Exception(Helper.extractErrorMessage(json, 'Algo sucedio mal, intentalo mas tarde'));
    }
  }
}