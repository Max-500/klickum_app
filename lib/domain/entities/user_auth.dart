class UserAuth {
  final String id;
  final String username;
  final String phone;
  final String email;
  final double balance;
  final bool isActive;

  UserAuth({required this.id, required this.username, required this.phone, required this.email, required this.balance, required this.isActive});

  UserAuth copyWith({
    String? id,
    String? username,
    String? phone,
    String? email,
    double? balance,
    bool? isActive
  }) => UserAuth(
    id: id ?? this.id, 
    username: username ?? this.username, 
    phone: phone ?? this.phone, 
    email: email ?? this.email, 
    balance: balance ?? this.balance, 
    isActive: isActive ?? this.isActive
  );
}