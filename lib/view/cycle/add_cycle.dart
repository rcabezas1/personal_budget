import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:personal_budget/model/cycle/budget_cycle.dart';
import 'package:personal_budget/view/cycle/cycle_card.dart';
import 'package:personal_budget/service/storage/memory_storage.dart';
import 'package:uuid/uuid.dart';

class AddCycles extends StatefulWidget {
  const AddCycles({super.key});

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
                  const Uuid().v4(),
                  "",
                  DateTime.now(),
                  DateTime.now(),
                  MemoryStorage.instance.userData?.fuid ?? "",
                  false),
              plan: const [],
              input: true,
            )));
  }
}
