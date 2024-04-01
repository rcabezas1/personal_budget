import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/plan/plan.dart';
import 'package:personal_budget/service/filters/filter_fields.dart';
import 'package:personal_budget/service/filters/filter_single_field.dart';
import 'package:personal_budget/service/mongo/mongo_request.dart';
import 'package:personal_budget/service/mongo/mongo_client.dart';
import 'package:personal_budget/storage/memory_storage.dart';
import 'dart:convert';

import 'filters/no_filter.dart';

final planCollection = dotenv.get("PLAN_COLLECTION");

class PlanService {
  Future<List<Plan>> findAll() async {
    List<Plan> data = [];
    try {
      var url = "$mongoService/find";

      Uri uri = Uri.parse(url);
      var client = MongoClient();
      var mongoBody = MongoRequest.filter(planCollection,
          filter: FilterSingleField(
              "fuid", MemoryStorage.instance.userData?.fuid ?? ""));
      String body = jsonEncode(mongoBody.toJson());
      final response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        debugPrint(body);
        var bodyJson =
            jsonDecode(const Utf8Decoder().convert(response.bodyBytes));

        for (var document in bodyJson['documents']) {
          data.add(Plan.fromJson(document));
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
