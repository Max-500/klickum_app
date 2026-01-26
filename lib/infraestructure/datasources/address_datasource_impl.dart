import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klicum/config/constants/enviroment.dart';
import 'package:klicum/config/constants/exceptions.dart';
import 'package:klicum/domain/datasources/address_datasource.dart';
import 'package:klicum/domain/entities/presentation/address_data.dart';
import 'package:klicum/domain/entities/presentation/countries_data.dart';
import 'package:klicum/infraestructure/mappers/address_mapper.dart';
import 'package:klicum/infraestructure/mappers/country_mapper.dart';
import 'package:klicum/infraestructure/models/address_response.dart';
import 'package:klicum/infraestructure/models/country_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressDatasourceImpl implements AddressDatasource {
  final Future<void> Function() onUnauthorized;
  final baseUrl = '${Enviroment.baseURL}/address';

  AddressDatasourceImpl({required this.onUnauthorized});

  @override
  Future<CountriesData> getCountries({int page = 1, int limit = 100}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/country').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString()
    });

    final response = await http.get(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );
    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en getAddress');
    }
    if (response.statusCode != 200) throw Exception('Error al obtener los paises disponibles');

    final json = jsonDecode(response.body);

    final countriesResponse = (json['items'] as List<dynamic>? ?? []).map((item) => CountryResponse.fromJson(item)).toList();

    final countries = countriesResponse.map((countryResponse) => CountryMapper.countryResponseToEntity(countryResponse)).toList();
    
    return CountriesData(totalPages: json['meta']?['totalPages'] ?? 0, countries: countries);
  }

  @override
  Future<String> saveAddress({required String zipCode, required String streetNumber, required String streetName, required String city, required int country}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final url = Uri.parse('${Enviroment.baseURL}/user/address');

    final response = await http.post(
      url, 
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'zipcode': zipCode,
        'streetNumber': streetNumber,
        'streetName': streetName,
        'countryId': country,
        'cityName': city
      })
    );

    if (response.statusCode == 401) {
      await onUnauthorized();
      throw SessionExpiredException(message: 'Sesión Terminada en saveAddress');
    }
    if (response.statusCode != 201) throw Exception('Error al guardar la dirección');

    final json = jsonDecode(response.body);

    return json['id'];
  }
  
  @override
  Future<AddressData> getAddress({int page = 1, int limit = 100}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final url = Uri.parse('${Enviroment.baseURL}/user/address/find').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString()
    });

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 401) throw SessionExpiredException(message: 'Sesión Terminada en getAddress');
    if (response.statusCode != 200) throw Exception('Error al obtener las direcciónes');

    final json = jsonDecode(response.body);

    final addressResponses = (json['items'] as List<dynamic>? ?? []).map((item) => AddressResponse.fromJson(item)).toList();

    final address = addressResponses.map((addressResponse) => AddressMapper.addressResponseToEntity(addressResponse)).toList();

    return AddressData(totalPages: json['meta']['totalPages'], address: address);
  }

}