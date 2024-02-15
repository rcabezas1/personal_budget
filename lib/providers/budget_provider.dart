import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:personal_budget/plan/plan.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:personal_budget/service/plan_service.dart';

import '../cycle/budget_cycle.dart';
import '../expenses/expense.dart';
import '../plan/plan_cycle.dart';
import '../service/cycle_service.dart';
import '../service/plan_cycle_service.dart';
import '../sms/sms_budget_builder.dart';

class BudgetProvider extends ChangeNotifier {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _smsMessages = [];
  final List<Expense> _budgetExpenses = [];
  List<Expense> _storedBudgetMessages = [];
  List<BudgetCycle> _budgetCycles = [];
  List<Plan> _plan = [];
  List<PlanCycle> _planCycle = [];

  bool smsAvailable = false;

  int get countCycles {
    return _budgetCycles.length;
  }

  BudgetCycle getCycles(int index) {
    return _budgetCycles[index];
  }

  Future<void> searchCycles(bool refresh) async {
    if (_budgetCycles.isEmpty || refresh) {
      _budgetCycles = await CycleService().findAll();
      _budgetCycles.sort((one, two) => two.startDate.compareTo(one.startDate));
    }
  }

  Future<void> searchPlan(bool refresh) async {
    if (_plan.isEmpty || refresh) {
      _plan = await PlanService().findAll();
      _plan.sort((one, two) => two.category!.compareTo(one.category!));
    }
  }

  Future<void> searchPlanCycle(bool refresh) async {
    if (_plan.isEmpty || refresh) {
      _planCycle = await PlanCycleService().findAll();
      _planCycle.sort((one, two) => two.category!.compareTo(one.category!));
    }
  }

  bool _validExpenseCycle(Expense expense) {
    if (expense.valid) {
      BudgetCycle cycle = _budgetCycles.firstWhere(
        (element) => element.enabled,
      );
      return expense.date!.isAfter(cycle.startDate);
    }
    return false;
  }

  int get countMessage {
    return _budgetExpenses.length;
  }

  Expense getMessage(int index) {
    return _budgetExpenses[index];
  }

  List<Expense> getExpenses() {
    return _budgetExpenses;
  }

  Future<void> searchMessages() async {
    await searchCycles(false);
    if (smsAvailable) {
      String addresses = dotenv.get("SMS_ADDRESS");
      if (addresses.isNotEmpty) {
        _smsMessages = [];
        for (var address in addresses.split(",")) {
          _smsMessages.addAll(await _query.querySms(
            kinds: [SmsQueryKind.inbox],
            address: address,
            count: int.parse(dotenv.get("SMS_COUNT", fallback: "100")),
          ));
        }
      }
    }
    _storedBudgetMessages = await ExpenseService().findAllValid();
    _processMessages();

    debugPrint('Messages: ${_budgetExpenses.length}');
    notifyListeners();
  }

  updateList() {
    _budgetExpenses.sort((one, two) => two.date!.compareTo(one.date!));
    notifyListeners();
  }

  _processMessages() {
    _budgetExpenses.clear();

    if (_smsMessages.isNotEmpty) {
      _addSmsMessages();
      _addNonSms();
    } else {
      _budgetExpenses.addAll(_storedBudgetMessages);
    }
    _budgetExpenses.sort((one, two) => two.date!.compareTo(one.date!));
  }

  _addNonSms() {
    var nonSmsMessages = _storedBudgetMessages.where((stored) =>
        _budgetExpenses.indexWhere((budget) => budget.id == stored.id) == -1);
    if (nonSmsMessages.isNotEmpty) {
      _budgetExpenses.addAll(nonSmsMessages);
    }
  }

  _addSmsMessages() {
    for (var message in _smsMessages) {
      String body = message.body ?? "";
      var expense = SmsBudgetBuilder.fromSMS(message.id, body);

      if (_validExpenseCycle(expense)) {
        expense.sms = message.body;
        var element = _storedBudgetMessages.firstWhere(
            (stored) => expense.id == stored.id,
            orElse: () => expense);
        _budgetExpenses.add(element);
      }
    }
  }

  List<Plan> getPlan() {
    return _plan;
  }

  List<PlanCycle> getPlanCycle() {
    return _planCycle;
  }
}
