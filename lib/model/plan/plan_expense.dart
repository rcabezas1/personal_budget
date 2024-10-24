import '../../service/mongo/mongo_number.dart';

class PlanExpense {
  String id;
  double value;

  PlanExpense(this.id, this.value);

  Map<String, dynamic> toJson() =>
      {'id': id, 'value': MongoNumberDouble(value)};

  static PlanExpense fromJson(Map<String, dynamic> json) => PlanExpense(
      json['id'] as String? ?? "", double.parse('${json['value'] ?? "0"}'));
}
