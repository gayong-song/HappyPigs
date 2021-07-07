class User {
  final String name;

  User({this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  @override
  String toString() {
    return 'User{name: $name}';
  }
}
