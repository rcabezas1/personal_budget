import 'package:personal_budget/service/mongo/mongo_number.dart';

class Plan {
  String? id;
  String fuid;
  String? clasification;
  String? category;
  double? value;

  Plan(this.fuid, {this.id, this.clasification, this.category, this.value});

  Map<String, dynamic> toJson() => {
        'clasification': clasification ?? "",
        'category': category ?? "",
        'value': MongoNumberDouble(value ?? 0),
      };

  static Plan fromJson(Map<String, dynamic> json) => Plan(
        json['fuid'] as String? ?? "",
        id: json['_id'] as String? ?? "",
        clasification: json['clasification'] as String? ?? "",
        category: json['category'] as String? ?? "",
        value: double.parse('${json['value'] ?? "0"}'),
      );
}
