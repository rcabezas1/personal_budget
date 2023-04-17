import 'package:personal_budget/service/filters/mongo_filter.dart';

class FilterValid implements MongoFilter {
  bool valid;
  FilterValid(this.valid);
  Map<String, dynamic> toJson() => <String, dynamic>{"valid": valid};
}
