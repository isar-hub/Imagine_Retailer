import 'package:imagine_retailer/models/Users.dart';

class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();

  factory UserSingleton() {
    return _instance;
  }

  UserSingleton._internal();

  Users? user;

  void setUser(Users? userModel) {
    user = userModel;
  }

  Users? getUser() {
    return user;
  }
}
