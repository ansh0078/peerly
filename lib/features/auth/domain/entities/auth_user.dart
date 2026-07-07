class AuthUser {
  final String id;
  final String name;
  final String email;
  final bool isVerified;
  final String? token;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
    this.token,
  });

  AuthUser copyWith({bool? isVerified, String? token}) => AuthUser(
        id: id,
        name: name,
        email: email,
        isVerified: isVerified ?? this.isVerified,
        token: token ?? this.token,
      );
}
