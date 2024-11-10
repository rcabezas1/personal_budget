import 'package:flutter/material.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text(
            'Agregar ciclos',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
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
