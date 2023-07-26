class User {
  String id;
  String username;
  String email;
  String token;
  bool isVerified = false;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      token: json['token'],
      isVerified: json['isVerified'],
      email: json['email'],
    );
  }
}
