import 'package:flutter/material.dart';
import 'package:personal_budget/sms/sms_parts.dart';

import '../budget/budget_message.dart';
import 'sms_templates.dart';

class SmsBudgetBuilder {
  static BudgetMessage fromSMS(int? id, String body) {
    SmsTypeTemplate? budgetTemplate = _getMessageType(body);
    var valid = budgetTemplate != null;
    if (valid) {
      BudgetMessage budget = BudgetMessage.valid('sms$id');
      budget.type = budgetTemplate.type;
      _getSmsParts(body, budgetTemplate).forEach((part) {
        switch (part.type) {
          case PartType.commerce:
            budget.commerce = part.value;
            break;
          case PartType.date:
            var dateParts = part.value.trim().split(" ");

            budget.date = _getDateTime(dateParts.first, dateParts.last);
            break;
          case PartType.value:
            budget.value = double.parse(part.value.replaceAll(',', ""));
            break;
          default:
        }
      });
      return budget;
    }
    return BudgetMessage.invalid("");
  }

  static SmsTypeTemplate? _getMessageType(String body) {
    for (var type in availableTypes) {
      var template = type.template.split("|");
      if (template.length > 3 &&
          body.startsWith(template[0]) &&
          body.contains(template[2]) &&
          body.contains(template[4]) &&
          body.contains(template[6])) {
        return type;
      }
    }
    return null;
  }

  static List<SmsParts> _getSmsParts(
      String body, SmsTypeTemplate templateType) {
    var templateParts = templateType.template.split("|");
    List<SmsParts> partTypes = [];
    for (var i = 0; i < templateParts.length; i++) {
      var templatePart = templateParts[i];
      var type = PartType.values.firstWhere((part) => templatePart == part.name,
          orElse: (() => PartType.undefined));
      if (type != PartType.undefined) {
        var previous = templateParts[i - 1];
        var next = templateParts[i + 1];
        var start = body.indexOf(previous) + previous.length;
        var end = body.lastIndexOf(next);
        if (start > -1 && end > -1) {
          partTypes.add(SmsParts(type, body.substring(start, end).trim()));
        }
      }
    }
    return partTypes;
  }

  static DateTime _getDateTime(String date, String time) {
    try {
      var fixedDate = date.replaceAll("/", "-");
      var fixedTime = _fixTime(time);
      return DateTime.parse('${fixedDate}T$fixedTime');
    } catch (e) {
      debugPrint('$e: $date $time');
      return DateTime.now();
    }
  }

  static String _fixTime(String time) {
    var splited = time.split(":");
    if (splited.isNotEmpty) {
      return '${splited[0].padLeft(2, "0")}:${splited[1].padLeft(2, "0")}:${splited[2].padLeft(2, "0")}';
    }
    return time;
  }
}
