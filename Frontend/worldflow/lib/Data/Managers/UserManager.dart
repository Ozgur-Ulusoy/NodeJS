class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  String? _id;

  String get Id => _id ?? "";

  set Id(String value) {
    _id = value;
  }
}
