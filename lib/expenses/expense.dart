import 'package:personal_budget/service/mongo/mongo_number.dart';

import '../service/mongo/mongo_date.dart';
import 'expense_type.dart';

class Expense {
  String id;
  String? commerce;
  double? value;
  DateTime? date;
  ExpenseType? type;
  String? sms;
  String? category;
  String? plan;
  String? description;
  double? initialValue;
  bool valid = false;

  Expense.valid(this.id,
      {this.commerce,
      this.value,
      this.date,
      this.type,
      this.sms,
      this.category,
      this.plan,
      this.description,
      this.initialValue}) {
    valid = true;
  }

  Expense.invalid(this.id) {
    valid = false;
  }

  Expense.manual(this.id) {
    type = ExpenseType.cash;
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
        'plan': plan ?? "",
        'description': description ?? "",
        'valid': valid,
        'initialValue': MongoNumberDouble(initialValue ?? value ?? 0),
      };

  static Expense fromJson(Map<String, dynamic> json) => Expense.valid(
        json['id'] as String? ?? "",
        commerce: json['commerce'] as String? ?? "",
        category: json['category'] as String? ?? "",
        plan: json['plan'] as String? ?? "",
        description: json['description'] as String? ?? "",
        sms: json['sms'] as String? ?? "",
        value: double.parse('${json['value'] ?? "0"}'),
        initialValue:
            double.parse('${json['initialValue'] ?? json['value'] ?? "0"}'),
        date: DateTime.parse(json['date']).toLocal(),
        type: ExpenseType.values
            .firstWhere((element) => element.nameType == json['type']),
      );
}
