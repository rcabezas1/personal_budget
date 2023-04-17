import 'mongo_number.dart';

class MongoDate {
  DateTime date;
  MongoDate(this.date);
  Map<String, dynamic> toJson() =>
      <String, dynamic>{"\$date": MongoNumberLong(date.millisecondsSinceEpoch)};
}
