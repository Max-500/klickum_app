class SessionExpiredException implements Exception {
  final String message;

  SessionExpiredException({required this.message});

  @override
  String toString() => "SessionExpiredException: $message";
}

class TokenRefreshException implements Exception {
  final String message;
  TokenRefreshException({required this.message});
  
  @override
  String toString() => 'TokenRefreshException: $message';
}

class TooManyRequestException implements Exception {
  final String message;

  TooManyRequestException({required this.message});

  @override
  String toString() => 'TooManyRequest: $message';
}