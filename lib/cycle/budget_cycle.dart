import '../service/mongo/mongo_date.dart';

class BudgetCycle {
  String id;
  DateTime startDate;
  DateTime endDate;
  String description;
  bool enabled;
  String fuid;
  String? mongoId;

  BudgetCycle(this.id, this.description, this.startDate, this.endDate,
      this.fuid, this.enabled,
      {this.mongoId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'startDate': MongoDate(startDate),
        'endDate': MongoDate(endDate),
        'fuid': fuid,
        'enabled': enabled,
        'valid': true,
      };

  static BudgetCycle fromJson(Map<String, dynamic> json) => BudgetCycle(
      json['id'] as String? ?? "",
      json['description'] as String? ?? "",
      DateTime.parse(json['startDate']).toLocal(),
      DateTime.parse(json['endDate']).toLocal(),
      json['fuid'] as String? ?? "",
      json['enabled'] as bool? ?? false,
      mongoId: json['_id'] as String?);
}
