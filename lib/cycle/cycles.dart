import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:personal_budget/cycle/cycle_card.dart';
import 'package:uuid/uuid.dart';

import 'budget_cycle.dart';

class Cycles extends StatefulWidget {
  const Cycles({Key? key}) : super(key: key);

  @override
  State<Cycles> createState() => _CyclesState();
}

class _CyclesState extends State<Cycles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          title: const Text('Ciclos de presupuesto'),
        ),
        body: SingleChildScrollView(
            restorationId: "cycles",
            child: CycleCard(
              cycle: BudgetCycle(
                  const Uuid().v4(), "", DateTime.now(), DateTime.now()),
            )));
  }
}
