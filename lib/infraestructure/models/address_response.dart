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

  factory AddressResponse.fromOrderJson(Map<String, dynamic> json) => AddressResponse(
    id: (json['id'] ?? '').toString(),
    zipCode: (json['zipcode'] ?? '').toString(),
    streetNumber: (json['streetNumber'] ?? '').toString(),
    streetName: (json['streetName'] ?? '').toString(),
    country: (json['city']?['country']?['name'] ?? '').toString(),
    city: (json['city']?['name'] ?? '').toString(),
  );
}