import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:personal_budget/budget/budget_card.dart';
import 'package:uuid/uuid.dart';

import 'budget_message.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => AddBudgetState();
}

class AddBudgetState extends State<AddBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          title: const Text('Agregar Gasto'),
          backgroundColor: GFColors.PRIMARY,
        ),
        body: SingleChildScrollView(
          restorationId: "manual",
          child: BudgetCard(
            message: BudgetMessage.manual("cash${const Uuid().v4()}"),
            input: true,
          ),
        ));
  }
}
