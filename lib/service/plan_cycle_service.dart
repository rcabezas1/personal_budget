import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/model/expenses/expense.dart';
import 'package:personal_budget/model/plan/plan_expense.dart';
import 'package:personal_budget/service/filters/filter_fields.dart';
import 'package:personal_budget/service/filters/filter_id.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'dart:convert';

import '../model/plan/plan_cycle.dart';
import 'storage/memory_storage.dart';

final collection = dotenv.get("PLAN_CYCLE_COLLECTION");

class PlanCycleService {
  Future<void> updateActualState(Expense newExpense) async {
    List<PlanCycle> planCycles = await findAll();
    for (var planCycle in planCycles) {
      var planExpenses = planCycle.expenses;
      bool changed = false;

      if (newExpense.plan == planCycle.id) {
        var founded = planExpenses.firstWhere(
          (element) => element.id == newExpense.id,
          orElse: () => PlanExpense("", 0),
        );
        if (founded.id == "") {
          planExpenses.add(PlanExpense(newExpense.id, newExpense.value ?? 0));
        } else {
          founded.value = newExpense.value!;
        }
        changed = true;
      } else if (planExpenses.any((element) => element.id == newExpense.id)) {
        planExpenses.removeWhere((element) => element.id == newExpense.id);
        changed = true;
      }

      if (changed) {
        await updateValuesAndSave(planCycle, planExpenses);
      }
    }
  }

  Future<void> updateValuesAndSave(
      PlanCycle planCycle, List<PlanExpense> planExpenses) async {
    planCycle.actualValue = planCycle.initialValue ?? 0;
    for (var planExpense in planExpenses) {
      planCycle.actualValue = planCycle.actualValue! - planExpense.value;
    }
    planCycle.expenses = planExpenses;
    planCycle.fuid = MemoryStorage.instance.userData?.fuid ?? "";
    await save(planCycle);
  }

  Future<String?> save(PlanCycle message) async {
    try {
      var client = MongoClient();
      var url = "${client.mongoService}/updateOne";
      Uri uri = Uri.parse(url);

      List<FieldsFilter> fields = [
        FieldsFilter("cycleId", message.cycleId ?? ""),
        FieldsFilter("planId", message.planId ?? "")
      ];

      var mongoBody = MongoRequest.upsert(
          client, collection, FilterFields(fields), message);
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
      var client = MongoClient();
      var url = "${client.mongoService}/find";
      Uri uri = Uri.parse(url);
      var mongoBody = MongoRequest.filter(client, collection,
          filter: FilterFields([
            FieldsFilter("valid", "true"),
            FieldsFilter("fuid", MemoryStorage.instance.userData?.fuid ?? "")
          ]));
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

  Future<void> deleteExpense(Expense toDelete) async {
    List<PlanCycle> planCycles = await findAll();
    PlanCycle planCycle = planCycles.firstWhere(
      (element) => element.id == toDelete.plan,
      orElse: () => PlanCycle(expenses: const [], fuid: ""),
    );
    if (planCycle.id != null) {
      var planExpenses = planCycle.expenses;
      planExpenses.removeWhere((element) => element.id == toDelete.id);
      await updateValuesAndSave(planCycle, planExpenses);
    }
  }

  Future<PlanCycle?> findOneById(String id) async {
    PlanCycle? data;
    try {
      var client = MongoClient();
      var url = "${client.mongoService}/findOne";
      Uri uri = Uri.parse(url);
      var mongoBody =
          MongoRequest.filter(client, collection, filter: FilterId(id));
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        debugPrint(body);
        var bodyJson =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        data = PlanCycle.fromJson(bodyJson);
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
