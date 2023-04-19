import 'package:personal_budget/service/mongo/mongo_number.dart';

import '../service/mongo/mongo_date.dart';
import 'budget_type.dart';

class BudgetMessage {
  String id;
  String? commerce;
  double? value;
  DateTime? date;
  BudgetType? type;
  String? sms;
  String? category;
  String? description;
  double? initialValue;
  bool valid = false;

  BudgetMessage.valid(this.id,
      {this.commerce,
      this.value,
      this.date,
      this.type,
      this.sms,
      this.category,
      this.description,
      this.initialValue}) {
    valid = true;
  }

  BudgetMessage.invalid(this.id) {
    valid = false;
  }

  BudgetMessage.manual(this.id) {
    type = BudgetType.cash;
    sms = "";
    valid = true;
    date = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'commerce': commerce ?? "",
        'value': MongoNumberDouble(value ?? 0),
        'date': MongoDate(date ?? DateTime.now()),
        'type': type?.nameType ?? "",
        'sms': sms ?? "",
        'category': category ?? "",
        'description': description ?? "",
        'valid': valid,
        'initialValue': MongoNumberDouble(initialValue ?? value ?? 0),
      };

  static BudgetMessage fromJson(Map<String, dynamic> json) =>
      BudgetMessage.valid(
        json['id'] as String? ?? "",
        commerce: json['commerce'] as String? ?? "",
        category: json['category'] as String? ?? "",
        description: json['description'] as String? ?? "",
        sms: json['sms'] as String? ?? "",
        value: double.parse('${json['value'] ?? "0"}'),
        initialValue:
            double.parse('${json['initialValue'] ?? json['value'] ?? "0"}'),
        date: DateTime.parse(json['date']).toLocal(),
        type: BudgetType.values
            .firstWhere((element) => element.nameType == json['type']),
      );
}
