class AuthToken {
  final String accessToken;
  final String refreshToken;
  AuthToken({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'acessToken': accessToken,
      "refreshToken": refreshToken,
    };
  }

  factory AuthToken.fromJson(Map<String, dynamic> jsonToken) {
    return AuthToken(
        accessToken: jsonToken['access_token'],
        refreshToken: jsonToken['refresh_token']);
  }
}
