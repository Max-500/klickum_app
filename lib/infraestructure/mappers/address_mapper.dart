import 'package:klicum/domain/entities/address.dart';
import 'package:klicum/infraestructure/models/address_response.dart';

class AddressMapper {
  static Address addressResponseToEntity(AddressResponse response) => Address(
    id: response.id, 
    zipCode: response.zipCode, 
    streetNumber: response.streetNumber, 
    streetName: response.streetName, 
    country: response.country, 
    city: response.city
  );
}