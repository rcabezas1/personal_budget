import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:personal_budget/cycle/budget_cycle.dart';
import 'package:personal_budget/service/mongo_budget_service.dart';
import 'package:personal_budget/service/mongo_cycle_service.dart';

import '../budget/budget_message.dart';
import '../sms/sms_budget_builder.dart';

class BudgetProvider extends ChangeNotifier {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _smsMessages = [];
  final List<BudgetMessage> _budgetMessages = [];
  List<BudgetCycle> _budgetCycles = [];
  List<BudgetMessage> _storedBudgetMessages = [];

  int get countMessage {
    return _budgetMessages.length;
  }

  int get countCycles {
    return _budgetCycles.length;
  }

  BudgetMessage getMessage(int index) {
    return _budgetMessages[index];
  }

  BudgetCycle getCycles(int index) {
    return _budgetCycles[index];
  }

  Future<void> searchCycles(bool refresh) async {
    if (_budgetCycles.isEmpty || refresh) {
      _budgetCycles = await MongoCycleService().findAll();
      _budgetCycles.sort((one, two) => two.startDate.compareTo(one.startDate));
    }

    notifyListeners();
  }

  Future<void> searchMessages() async {
    await searchCycles(false);

    _smsMessages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      address: '87705',
      count: 100,
    );
    _storedBudgetMessages = await MongoBudgetService().findAllValid();
    _processMessages();

    debugPrint('Messages: ${_budgetMessages.length}');
    notifyListeners();
  }

  updateList() {
    _budgetMessages.sort((one, two) => two.date!.compareTo(one.date!));
    notifyListeners();
  }

  _processMessages() {
    _budgetMessages.clear();

    if (_smsMessages.isNotEmpty) {
      _addSmsMessages();
      _addNonSms();
    } else {
      _budgetMessages.addAll(_storedBudgetMessages);
    }
    _budgetMessages.sort((one, two) => two.date!.compareTo(one.date!));
  }

  _addNonSms() {
    var nonSmsMessages = _storedBudgetMessages.where((stored) =>
        _budgetMessages.indexWhere((budget) => budget.id == stored.id) == -1);
    if (nonSmsMessages.isNotEmpty) {
      _budgetMessages.addAll(nonSmsMessages);
    }
  }

  _addSmsMessages() {
    for (var message in _smsMessages) {
      String body = message.body ?? "";
      var budget = SmsBudgetBuilder.fromSMS(message.id, body);
      if (_validCycle(budget)) {
        budget.sms = message.body;
        var element = _storedBudgetMessages.firstWhere(
            (stored) => budget.id == stored.id,
            orElse: () => budget);
        _budgetMessages.add(element);
      }
    }
  }

  bool _validCycle(BudgetMessage message) {
    if (message.valid) {
      BudgetCycle cycle =
          _budgetCycles.firstWhere((element) => element.enabled);
      return message.date!.isAfter(cycle.startDate);
    }
    return false;
  }
}
