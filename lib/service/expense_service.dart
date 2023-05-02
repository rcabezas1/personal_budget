import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/cycle/budget_cycle.dart';
import 'package:personal_budget/service/filters/filter_date.dart';
import 'package:personal_budget/service/filters/filter_id.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'package:personal_budget/service/partial/budget_cycle_update.dart';
import 'dart:convert';

import '../expenses/expense.dart';

final expenseCollection = dotenv.get("BUDGET_COLLECTION");

class ExpenseService {
  Future<void> save(Expense message) async {
    try {
      var url = "$mongoService/updateOne";

      Uri uri = Uri.parse(url);
      var client = MongoClient();

      var mongoBody =
          MongoRequest.upsert(expenseCollection, FilterId(message.id), message);
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
          expenseCollection,
          FilterDate(cycle.startDate, cycle.endDate, "date"),
          BudgetCycleUpdate(cycle.mongoId ?? '', cycle.enabled));
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
      var mongoBody = MongoRequest.delete(expenseCollection, FilterId(id));
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

  Future<List<Expense>> findAllValid() async {
    List<Expense> data = [];
    try {
      var url = "$mongoService/find";

      Uri uri = Uri.parse(url);
      var client = MongoClient();
      var mongoBody = MongoRequest.filter(expenseCollection);
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        debugPrint(body);
        var bodyJson =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

        for (var document in bodyJson['documents']) {
          data.add(Expense.fromJson(document));
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
