import 'package:personal_budget/model/plan/plan_expense.dart';
import 'package:personal_budget/service/mongo/mongo_number.dart';

class PlanCycle {
  String? id;
  String? clasification;
  String? category;
  String? cycleId;
  String? planId;
  String fuid;
  List<PlanExpense> expenses;
  double? initialValue;
  double? actualValue;

  bool valid;

  PlanCycle(
      {this.id,
      this.clasification,
      this.category,
      this.cycleId,
      this.planId,
      this.initialValue,
      this.actualValue,
      required this.expenses,
      required this.fuid,
      this.valid = true});

  Map<String, dynamic> toJson() => {
        'clasification': clasification ?? "",
        'category': category ?? "",
        'cycleId': cycleId ?? "",
        'planId': planId ?? "",
        'initialValue': MongoNumberDouble(initialValue ?? 0),
        'actualValue': MongoNumberDouble(actualValue ?? 0),
        'expenses': expenses.map((expenseId) => expenseId).toList(),
        'fuid': fuid,
        'valid': valid,
      };

  static PlanCycle fromJson(Map<String, dynamic> json) => PlanCycle(
        id: json['_id'] as String? ?? "",
        clasification: json['clasification'] as String? ?? "",
        category: json['category'] as String? ?? "",
        cycleId: json['cycleId'] as String? ?? "",
        planId: json['planId'] as String? ?? "",
        initialValue: double.parse('${json['initialValue'] ?? "0"}'),
        actualValue: double.parse('${json['actualValue'] ?? "0"}'),
        expenses: getExpenses(json['expenses'] ?? []),
        fuid: json['fuid'] as String? ?? "",
        valid: json['valid'] as bool? ?? false,
      );

  static List<PlanExpense> getExpenses(List<dynamic> json) {
    return json.map((e) => PlanExpense.fromJson(e)).toList();
  }
}
