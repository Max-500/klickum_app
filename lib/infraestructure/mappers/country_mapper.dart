import 'package:klicum/domain/entities/country.dart';
import 'package:klicum/infraestructure/models/country_response.dart';

class CountryMapper {
  static Country countryResponseToEntity(CountryResponse response) => Country(
    id: response.id, 
    name: response.name, 
    iso: response.iso, 
    phoneCode: response.phoneCode
  );
}