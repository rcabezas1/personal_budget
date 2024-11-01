import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_budget/model/plan/plan.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:personal_budget/service/plan_service.dart';
import 'package:personal_budget/model/cycle/budget_cycle.dart';
import 'package:personal_budget/model/expenses/expense.dart';
import 'package:personal_budget/model/plan/plan_cycle.dart';
import 'package:personal_budget/service/cycle_service.dart';
import 'package:personal_budget/service/plan_cycle_service.dart';

class BudgetProvider extends ChangeNotifier {
  final List<Expense> _budgetExpenses = [];
  List<Expense> _storedBudgetMessages = [];
  List<BudgetCycle> _budgetCycles = [];
  List<Plan> _plan = [];
  List<PlanCycle> _planCycle = [];

  bool smsAvailable = false;

  int get countCycles {
    return _budgetCycles.length;
  }

  int get countPlan {
    return _planCycle.length;
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
      notifyListeners();
    }
  }

  Future<void> searchPlanCycle(bool refresh) async {
    if (_plan.isEmpty || refresh) {
      _planCycle = await PlanCycleService().findAll();
      defaultSortPlanCycle();
      notifyListeners();
    }
  }

  defaultSortPlanCycle() {
    _planCycle.sort((one, two) => one.category!.compareTo(two.category!));
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

  Expense getExpense(int index) {
    return _budgetExpenses[index];
  }

  List<Expense> getExpenses() {
    return _budgetExpenses;
  }

  Future<void> searchExpenses() async {
    await searchCycles(false);
    if (smsAvailable) {}
    _storedBudgetMessages = await ExpenseService().findAllValid();
    _processExpenses();
    notifyListeners();
  }

  updateList() {
    _budgetExpenses.sort((one, two) => two.date!.compareTo(one.date!));
    notifyListeners();
  }

  _processExpenses() {
    _budgetExpenses.clear();
    _budgetExpenses.addAll(_storedBudgetMessages);
    defaultSortExpenses();
  }

  defaultSortExpenses() {
    _budgetExpenses.sort((one, two) => two.date!.compareTo(one.date!));
  }

  sortExpensesSearch(String search) {
    _budgetExpenses.sort((one, two) => _sortString(
        one.description?.toLowerCase() ?? "",
        two.description?.toLowerCase() ?? "",
        search.toLowerCase().trim()));
  }

  sortPlanCycles(String search) {
    _planCycle.sort((one, two) => _sortString(one.category?.toLowerCase() ?? "",
        two.category?.toLowerCase() ?? "", search.toLowerCase().trim()));
  }

  _sortString(String one, String two, String search) {
    if (one.contains(search) && two.contains(search)) {
      return 0;
    } else if (one.contains(search)) {
      return -1;
    } else if (two.contains(search)) {
      return 1;
    }
    return 0;
  }

  _addNonSms() {
    var nonSmsMessages = _storedBudgetMessages.where((stored) =>
        _budgetExpenses.indexWhere((budget) => budget.id == stored.id) == -1);
    if (nonSmsMessages.isNotEmpty) {
      _budgetExpenses.addAll(nonSmsMessages);
    }
  }

  List<Plan> getPlan() {
    return _plan;
  }

  List<PlanCycle> getPlanCycle() {
    return _planCycle;
  }

  PlanCycle getPlanCycleItem(int index) {
    return _planCycle[index];
  }

  Future<List<PlanCycle>> getUpdatedPlanCycle() async {
    await searchPlanCycle(true);
    return _planCycle;
  }
}
