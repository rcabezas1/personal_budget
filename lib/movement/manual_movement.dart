import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:personal_budget/budget/budget_card.dart';
import 'package:uuid/uuid.dart';

import '../budget/budget_message.dart';

class ManualMovement extends StatefulWidget {
  const ManualMovement({Key? key}) : super(key: key);

  @override
  State<ManualMovement> createState() => ManualMovementState();
}

class ManualMovementState extends State<ManualMovement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          title: const Text('Agregar Gasto'),
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
