class User {
  final String id;
  final String name;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> jsonUser) {
    return User(
      id: jsonUser["_id"],
      name: jsonUser["name"],
      phoneNumber: jsonUser["phoneNumber"],
    );
  }
}
