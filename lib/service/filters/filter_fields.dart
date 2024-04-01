import 'mongo_filter.dart';

class FilterFields implements MongoFilter {
  List<FieldsFilter> fields;
  FilterFields(this.fields);
  Map<String, dynamic> toJson() => <String, dynamic>{
        "\$and": fields.map((field) => field.toJson()).toList()
      };
}

class FieldsFilter {
  String property;
  String value;
  FieldsFilter(this.property, this.value);
  Map<String, dynamic> toJson() =>
      <String, dynamic>{property: value == "true" ? true : value};
}
