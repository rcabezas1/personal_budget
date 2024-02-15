import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/expenses/expense.dart';
import 'package:personal_budget/plan/plan.dart';
import 'package:personal_budget/service/filters/filter_fields.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'dart:convert';

import '../plan/plan_cycle.dart';

final collection = dotenv.get("PLAN_CYCLE_COLLECTION");

class PlanCycleService {
  Future<void> updateActualState(Expense newExpense, List<Expense> expenses,
      List<PlanCycle> planCycles) async {
    List<Expense> totalExpense = expenses;

    var existNewExpense =
        expenses.any((element) => element.id == newExpense.id);
    if (existNewExpense) {
      totalExpense.removeWhere((element) => element.id == newExpense.id);
    }
    totalExpense.add(newExpense);

    for (var planCycle in planCycles) {
      var planExpenses = planCycle.expenses;
      bool changed = false;
      if (planExpenses.any((element) => element == newExpense.id)) {
        planExpenses.removeWhere((element) => element == newExpense.id);
        changed = true;
      }
      if (planCycle.id == newExpense.plan) {
        planExpenses.add(newExpense.id);
        changed = true;
      }
      if (changed) {
        planCycle.actualValue = planCycle.initialValue ?? 0;
        for (var expenseId in planExpenses) {
          var founded =
              totalExpense.firstWhere((expense) => expense.id == expenseId);
          planCycle.actualValue = planCycle.actualValue! - (founded.value ?? 0);
        }
        planCycle.expenses = planExpenses;
        await save(planCycle);
      }
    }
  }

  Future<String?> save(PlanCycle message) async {
    try {
      var url = "$mongoService/updateOne";

      Uri uri = Uri.parse(url);
      var client = MongoClient();

      List<FieldsFilter> fields = [
        FieldsFilter("cycleId", message.cycleId ?? ""),
        FieldsFilter("planId", message.planId ?? "")
      ];

      var mongoBody =
          MongoRequest.upsert(collection, FilterFields(fields), message);
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

  Future<List<PlanCycle>> findAll() async {
    List<PlanCycle> data = [];
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
          data.add(PlanCycle.fromJson(document));
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
