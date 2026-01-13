class UserAuthResponse {
  final String id;
  final String username;
  final String phone;
  final String email;
  final double balance;
  final bool isActive;

  UserAuthResponse({required this.id, required this.username, required this.phone, required this.email, required this.balance, required this.isActive});

  factory UserAuthResponse.fromJson(Map<String, dynamic> json) => UserAuthResponse(
    id: json['id'], 
    username: json['username'], 
    phone: json['phone'], 
    email: json['email'], 
    balance: double.tryParse(json['balance']) ?? -1, 
    isActive: json['isActive']
  );
}