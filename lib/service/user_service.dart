import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/service/filters/filter_single_field.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'package:personal_budget/user/user_data.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../storage/memory_storage.dart';

final collection = dotenv.get("USER_COLLECTION");

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

  Future<String?> save(UserData message) async {
    try {
      var client = MongoClient(defaultApiKey: true);
      var url = "${client.mongoService}/updateOne";
      Uri uri = Uri.parse(url);
      var mongoBody = MongoRequest.upsert(
          client, collection, FilterSingleField("uid", message.uid), message);
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.body;
        debugPrint(data);
        return jsonDecode(data)['upsertedId'];
      } else {
        debugPrint(body);
        debugPrint('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<UserData>> findAll() async {
    List<UserData> data = [];
    try {
      var client = MongoClient(defaultApiKey: true);
      var url = "${client.mongoService}/find";
      Uri uri = Uri.parse(url);
      var mongoBody = MongoRequest.filter(client, collection);
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        debugPrint(body);
        var bodyJson =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

        for (var document in bodyJson['documents']) {
          data.add(UserData.fromJson(document));
        }
      } else {
        debugPrint(body);
        debugPrint('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return data;
  }

  Future<UserData?> findOneById(String uid) async {
    UserData? data;
    try {
      var client = MongoClient(defaultApiKey: true);
      var url = "${client.mongoService}/findOne";
      Uri uri = Uri.parse(url);
      var mongoBody = MongoRequest.filter(client, collection,
          filter: FilterSingleField("uid", uid));
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        debugPrint(body);
        var bodyJson =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        data = UserData.fromJson(bodyJson['document']);
      } else {
        debugPrint(body);
        debugPrint('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return data;
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
    if (MemoryStorage.instance.token != null) {}
  }

  Future<UserData> singin(User? user) async {
    debugPrint("DEBUG USER:::::$user");
    if (user != null) {
      var founded = await findOneById(user.uid);
      var fuid = "";
      var apiKey = "";
      var dashboard = "";
      var dataApi = "";
      var dataBase = "";
      var dataSource = "";
      if (founded == null || founded.uid == "") {
        fuid = const Uuid().v4();
        apiKey = dotenv.get("MONGO_API_KEY");
        dashboard = dotenv.get("CHARTS");
        dataApi = dotenv.get("MONGO_SERVICE");
        dataBase = dotenv.get("DATABASE");
        dataSource = dotenv.get("DATASOURCE");
      } else {
        fuid = founded.fuid;
        apiKey = founded.apiKey;
        dashboard = founded.dashboard;
        dataApi = founded.dataApi;
        dataBase = founded.dataBase;
        dataSource = founded.dataSource;
      }
      var userData = UserData(
          user.uid,
          user.email ?? "",
          user.displayName ?? "",
          user.photoURL ?? "",
          fuid,
          apiKey,
          dashboard,
          dataApi,
          dataBase,
          dataSource);
      save(userData);
      return userData;
    }
    throw Exception('Empty user');
  }
}
