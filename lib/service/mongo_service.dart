import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/service/mongo_request.dart';
import 'package:personal_budget/service/mongo_client.dart';
import 'dart:convert';

import '../budget/budget_message.dart';

final collection = dotenv.get("BUDGET_COLLECTION");
final mongoService = dotenv.get("MONGO_SERVICE");

class MongoService {
  Future<void> saveBudgetMessage(BudgetMessage message) async {
    try {
      var url = "$mongoService/updateOne";

      Uri uri = Uri.parse(url);
      var client = MongoClient();

      var mongoBody = MongoRequest.upsert(collection, message.id, message);
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.body;
        debugPrint(data);
      } else {
        debugPrint(body);
        debugPrint('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> deleteBudgetMessage(String id) async {
    try {
      var url = "$mongoService/deleteOne";

      Uri uri = Uri.parse(url);
      var client = MongoClient();
      var mongoBody = MongoRequest.delete(collection, id);
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.body;
        debugPrint(data);
        return true;
      } else {
        debugPrint(body);
        debugPrint('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<List<BudgetMessage>> getBudgetMessages() async {
    List<BudgetMessage> data = [];
    try {
      var url = "$mongoService/find";

      Uri uri = Uri.parse(url);
      var client = MongoClient();
      var mongoBody = MongoRequest.filter(collection);
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        debugPrint(body);
        var bodyJson =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

        for (var document in bodyJson['documents']) {
          data.add(BudgetMessage.fromJson(document));
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
}
