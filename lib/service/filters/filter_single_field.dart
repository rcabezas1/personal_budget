import 'mongo_filter.dart';

class FilterSingleField implements MongoFilter {
  String filter;
  String value;
  FilterSingleField(this.filter, this.value);
  Map<String, dynamic> toJson() =>
      <String, dynamic>{filter: value == "true" ? true : value};
}
