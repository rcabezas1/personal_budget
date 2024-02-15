import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:personal_budget/cycle/cycle_card.dart';
import 'package:uuid/uuid.dart';

import 'budget_cycle.dart';

class AddCycles extends StatefulWidget {
  const AddCycles({Key? key}) : super(key: key);

  @override
  State<AddCycles> createState() => _AddCyclesState();
}

class _AddCyclesState extends State<AddCycles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          backgroundColor: GFColors.PRIMARY,
          title: const Text('Agregar ciclos'),
        ),
        body: SingleChildScrollView(
            restorationId: "cycles",
            child: CycleCard(
              cycle: BudgetCycle(
                  const Uuid().v4(), "", DateTime.now(), DateTime.now(), false),
              plan: [],
              input: true,
            )));
  }
}
