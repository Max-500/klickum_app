class CategoryResponse {
  final String id;
  final String name;

  CategoryResponse({required this.id, required this.name});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(id: json['id'], name: json['name']);
}