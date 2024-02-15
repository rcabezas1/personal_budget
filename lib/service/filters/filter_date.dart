import 'package:personal_budget/service/filters/mongo_filter.dart';
import 'package:personal_budget/service/mongo/mongo_date.dart';

class FilterDate implements MongoFilter {
  DateTime startDate;
  DateTime endDate;
  String field;
  FilterDate(this.startDate, this.endDate, this.field);
  Map<String, dynamic> toJson() => <String, dynamic>{
        field: FilterDateBetween(startDate, endDate, "gte", "lt"),
      };
}

class FilterDateBetween {
  String gtField;
  String ltField;
  DateTime startDate;
  DateTime endDate;

  FilterDateBetween(this.startDate, this.endDate, this.gtField, this.ltField);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "\$$gtField": MongoDate(startDate),
        "\$$ltField": MongoDate(endDate)
      };
}

class FilterTypeDate {
  String type;
  DateTime date;

  FilterTypeDate(this.type, this.date);
  Map<String, dynamic> toJson() =>
      <String, dynamic>{"\$$type": MongoDate(date)};
}

/*

"createdAt": {
          "$gte": { "$date": { "$numberLong": "1640995200000" } },
          "$lt": { "$date": { "$numberLong": "1672531200000" } }
        }

*/