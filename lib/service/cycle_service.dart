import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/model/cycle/budget_cycle.dart';
import 'package:personal_budget/service/filters/filter_id.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'dart:convert';

import 'storage/memory_storage.dart';
import 'filters/filter_fields.dart';

final collection = dotenv.get("CYCLE_COLLECTION");

class CycleService {
  Future<String?> save(BudgetCycle message) async {
    try {
      var client = MongoClient();
      var url = "${client.mongoService}/updateOne";
      Uri uri = Uri.parse(url);

      var mongoBody = MongoRequest.upsert(
          client, collection, FilterId(message.id), message);
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

  Future<bool> delete(String id) async {
    try {
      var client = MongoClient();
      var url = "${client.mongoService}/deleteOne";
      Uri uri = Uri.parse(url);
      var mongoBody = MongoRequest.delete(client, collection, FilterId(id));
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

  Future<List<BudgetCycle>> findAll() async {
    List<BudgetCycle> data = [];
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
          data.add(BudgetCycle.fromJson(document));
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
