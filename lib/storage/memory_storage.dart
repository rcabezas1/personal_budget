import 'package:flutter/material.dart';

import '../user/user_data.dart';

class MemoryStorage {
  MemoryStorage._privateConstructor();
  static final MemoryStorage instance = MemoryStorage._privateConstructor();

  UserData? userData;
  String? token;
  bool notifications = false;
  int totalNotifications = 0;

  DateTime? start;

  void startTimer() {
    start = DateTime.now();
  }

  void endTimer(String identifier) {
    if (start != null) {
      int diff = DateTime.now().difference(start!).inMilliseconds;
      debugPrint("Tiempo transcurrido:::$identifier:::$diff");
    }
  }

  void clearData() {
    userData = null;
    token = null;
    notifications = false;
  }
}
