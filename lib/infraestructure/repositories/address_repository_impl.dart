import 'package:klicum/domain/datasources/address_datasource.dart';
import 'package:klicum/domain/entities/presentation/address_data.dart';
import 'package:klicum/domain/entities/presentation/countries_data.dart';
import 'package:klicum/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressDatasource datasource;

  AddressRepositoryImpl({required this.datasource});

  @override
  Future<CountriesData> getCountries({int page = 1, int limit = 100}) async => await datasource.getCountries(page: page, limit: limit);
  
  @override
  Future<String> saveAddress({required String zipCode, required String streetNumber, required String streetName, required String city, required int country}) async => await datasource.saveAddress(zipCode: zipCode, streetNumber: streetNumber, streetName: streetName, city: city, country: country);

  @override
  Future<AddressData> getAddress({int page = 1, int limit = 100}) async => await datasource.getAddress(page: page, limit: limit);
}