import 'mongo_filter.dart';

class FilterId implements MongoFilter {
  String id;
  FilterId(this.id);
  Map<String, dynamic> toJson() => <String, dynamic>{"id": id};
}
