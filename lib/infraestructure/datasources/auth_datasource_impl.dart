import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/helper.dart';
import 'package:klicum/domain/datasources/auth_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final String baseURL = '${Enviroment.baseURL}/auth';

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
    final url = Uri.parse('$baseURL/signup');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(),
        'password': password.trim()
      })
    );

    if (response.statusCode == 401) throw Exception('Credenciales Incorrectas');
    if (response.statusCode != 200) throw Exception('Error al iniciar sesión, intentalo mas tarde');

    final json = jsonDecode(response.body);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', json['access_token']);
  }

}