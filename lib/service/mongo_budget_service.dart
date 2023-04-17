import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/cycle/budget_cycle.dart';
import 'package:personal_budget/service/filters/filter_date.dart';
import 'package:personal_budget/service/filters/filter_id.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'package:personal_budget/service/partial/budget_cycle_update.dart';
import 'dart:convert';

import '../budget/budget_message.dart';

final budgetCollection = dotenv.get("BUDGET_COLLECTION");

class MongoBudgetService {
  Future<void> save(BudgetMessage message) async {
    try {
      var url = "$mongoService/updateOne";

      Uri uri = Uri.parse(url);
      var client = MongoClient();

      var mongoBody =
          MongoRequest.upsert(budgetCollection, FilterId(message.id), message);
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

  Future<void> updateCycle(BudgetCycle cycle) async {
    try {
      var url = "$mongoService/updateMany";

      Uri uri = Uri.parse(url);
      var client = MongoClient();

      var mongoBody = MongoRequest.updateAll(
          budgetCollection,
          FilterDate(cycle.startDate, cycle.endDate, "date"),
          BudgetCycleUpdate(cycle.mongoId ?? '', false));
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint(body);
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

  Future<bool> delete(String id) async {
    try {
      var url = "$mongoService/deleteOne";

      Uri uri = Uri.parse(url);
      var client = MongoClient();
      var mongoBody = MongoRequest.delete(budgetCollection, FilterId(id));
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

  Future<List<BudgetMessage>> findAllValid() async {
    List<BudgetMessage> data = [];
    try {
      var url = "$mongoService/find";

      Uri uri = Uri.parse(url);
      var client = MongoClient();
      var mongoBody = MongoRequest.filter(budgetCollection);
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
