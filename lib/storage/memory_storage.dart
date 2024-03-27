import '../user/user_data.dart';

class MemoryStorage {
  MemoryStorage._privateConstructor();
  static final MemoryStorage instance = MemoryStorage._privateConstructor();

  UserData? userData;
  String? token;
  bool notifications = false;
  int totalNotifications = 0;

  void clearData() {
    userData = null;
    token = null;
    notifications = false;
  }
}
