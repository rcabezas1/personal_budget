import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../storage/memory_storage.dart';
import 'user_data.dart';

class UserService {
  Future<ThemeMode> themeMode(UserData? userData) async {
    if (userData == null) {
      return ThemeMode.system;
    } else {
      switch (userData.theme) {
        case "system":
          return ThemeMode.system;
        case "dark":
          return ThemeMode.dark;
        case "light":
          return ThemeMode.light;
      }
      return ThemeMode.system;
    }
  }

  Future<UserData> updateUser(UserData userData) async {
    /*var url = Uri.parse(AppConfig.updateUser);
    String body = jsonEncode(userData);
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return UserData.fromJson(json.decode(response.body));
    }*/
    return userData;
  }

  Future<void> singout() async {
    if (MemoryStorage.instance.token != null) {
      /*var url = Uri.parse(AppConfig.singout);
      await http.get(url, headers: headers);*/
    }
  }

  Future<UserData> singin(String? token) async {
    if (kDebugMode) {
      debugPrint("DEBUG TOKEN:::::$token");
    }

    if (token != null) {
      /* MemoryStorage.instance.token = token;
      var url = Uri.parse(AppConfig.singin);
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return UserData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error ${response.statusCode}: ${response.toString()}');
      }*/
      return UserData("", "email", "name", "picture");
    }
    throw Exception('Empty token');
  }
}
