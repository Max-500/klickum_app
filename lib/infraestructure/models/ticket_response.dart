class TicketResponse {
  final String id;
  final bool isActive;
  final String code;
  final bool isMyTikcet;

  TicketResponse({required this.id, required this.isActive, required this.code, required this.isMyTikcet});

  factory TicketResponse.fromJson(Map<String, dynamic> json, String id) => TicketResponse(
    id: json['id'], 
    isActive: json['isActive'], 
    code: json['code'].toString(), 
    isMyTikcet: json['user']['id'] == id
  );
}