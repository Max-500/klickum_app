import 'package:klicum/domain/entities/presentation/address_data.dart';
import 'package:klicum/domain/entities/presentation/countries_data.dart';

abstract class AddressRepository {
  Future<CountriesData> getCountries({int page = 1, int limit = 100});
  Future<String> saveAddress({ required String zipCode, required String streetNumber, required String streetName, required String city, required int country });
  Future<AddressData> getAddress({ int page = 1, int limit = 100 });
}