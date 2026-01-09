class AddressResponse {
  final String id;
  final String zipCode;
  final String streetNumber;
  final String streetName;
  final String country;
  final String city;

  AddressResponse({required this.id, required this.zipCode, required this.streetNumber, required this.streetName, required this.country, required this.city});

  factory AddressResponse.fromJson(Map<String, dynamic> json) => AddressResponse(
    id: json['id'], 
    zipCode: json['zipcode'], 
    streetNumber: json['streetNumber'], 
    streetName: json['streetName'], 
    country: json['city']['country']['nombre'], 
    city: json['city']['name']
  );
}