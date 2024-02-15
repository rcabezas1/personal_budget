import 'package:personal_budget/service/filters/mongo_filter.dart';

class NoFilter implements MongoFilter {
  NoFilter();
  Map<String, dynamic> toJson() => <String, dynamic>{};
}
