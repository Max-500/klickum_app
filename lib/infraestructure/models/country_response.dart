class CountryResponse {
  final int id;
  final String name;
  final String iso;
  final String phoneCode;

  CountryResponse({required this.id, required this.name, required this.iso, required this.phoneCode});

  factory CountryResponse.fromJson(Map<String, dynamic> json) => CountryResponse(
    id: json['id'], 
    name: json['nombre'] ?? json['nom'] ?? json['name'], 
    iso: json['iso2'], 
    phoneCode: json['phone_code']
  );
}