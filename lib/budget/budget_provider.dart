import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:personal_budget/service/mongo_service.dart';

import '../budget/budget_message.dart';
import '../sms/sms_budget_builder.dart';

class BudgetProvider extends ChangeNotifier {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _smsMessages = [];
  final List<BudgetMessage> _budgetMessages = [];
  List<BudgetMessage> _storedBudgetMessages = [];

  int get countMessage {
    return _budgetMessages.length;
  }

  BudgetMessage getMessage(int index) {
    return _budgetMessages[index];
  }

  Future<void> searchMessages() async {
    _smsMessages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      address: '87705',
      count: 100,
    );
    _storedBudgetMessages = await MongoService().getBudgetMessages();
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
      if (budget.valid) {
        budget.sms = message.body;
        var element = _storedBudgetMessages.firstWhere(
            (stored) => budget.id == stored.id,
            orElse: () => budget);
        _budgetMessages.add(element);
      }
    }
  }
}
