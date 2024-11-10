import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_budget/model/plan/plan.dart';
import 'package:personal_budget/model/plan/plan_cycle.dart';
import 'package:personal_budget/service/providers/budget_provider.dart';
import 'package:personal_budget/model/cycle/budget_cycle.dart';
import 'package:personal_budget/service/storage/memory_storage.dart';
import 'package:personal_budget/view/inputs/formats.dart';
import 'package:personal_budget/view/loaders/avatar_loader.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:personal_budget/service/cycle_service.dart';
import 'package:personal_budget/service/plan_cycle_service.dart';
import 'package:provider/provider.dart';

class CycleCard extends StatefulWidget {
  CycleCard(
      {super.key,
      required this.cycle,
      required this.input,
      required this.plan,
      this.delete,
      this.update}) {
    selectedToggle[0] = cycle.enabled == true;
    selectedToggle[1] = cycle.enabled == false;
  }

  final BudgetCycle cycle;
  final bool input;
  final List<Plan> plan;
  final AsyncValueSetter<BudgetCycle>? delete;
  final AsyncValueSetter<BudgetCycle>? update;

  final List<bool> selectedToggle = <bool>[true, false];

  @override
  CycleCardState createState() => CycleCardState();
}

const List<Widget> toggle = <Widget>[Text('Activo'), Text('Inactivo')];

class CycleCardState extends State<CycleCard> {
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    //_selectedToggle[0] = widget.cycle.enabled == true;
    //_selectedToggle[1] = widget.cycle.enabled == false;
    return Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Colors.grey.shade50,
        child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            titleAlignment: ListTileTitleAlignment.top,
            title: Row(
              spacing: 10,
              children: [
                AvatarLoader(saving: saving, avatar: "cycle"),
                _inputDescription()
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: _getInputs(),
            )));
  }

  List<Widget> _getInputs() {
    return [
      _toggleActive(),
      const SizedBox(height: 10),
      _inputDate(),
      const SizedBox(height: 10),
      _buttons(),
      _buttonsAdditional()
    ];
  }

  _inputDescription() {
    return Expanded(
        child: TextFormField(
      decoration: const InputDecoration(
        hintText: 'Descripcion',
      ),
      initialValue: widget.cycle.description,
      onChanged: _setDescription,
    ));
  }

  _setDescription(String description) {
    setState(() {
      widget.cycle.description = description.trim();
    });
  }

  _inputDate() {
    return FilledButton.tonal(
      onPressed: _datePicker,
      child: Text(
          '${dateFormat.format(widget.cycle.startDate)} \n ${dateFormat.format(widget.cycle.endDate)} '),
    );
  }

  _toggleActive() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < widget.selectedToggle.length; i++) {
            widget.selectedToggle[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor:
          widget.selectedToggle[0] ? Colors.green[900] : Colors.blueGrey,
      selectedColor: Colors.white,
      fillColor: widget.selectedToggle[0] ? Colors.green[900] : Colors.blueGrey,
      color: Colors.green[900],
      constraints: const BoxConstraints(
        minHeight: 30.0,
        minWidth: 90.0,
      ),
      isSelected: widget.selectedToggle,
      children: toggle,
    );
  }

  _datePicker() async {
    DateTime startDate = widget.cycle.startDate;
    DateTime endDate = widget.cycle.endDate;
    DateTimeRange? pickedRange = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(start: startDate, end: endDate),
        firstDate: startDate.subtract(const Duration(days: 100)),
        lastDate: endDate.add(const Duration(days: 30)),
        saveText: "Seleccionar",
        useRootNavigator: false,
        currentDate: DateTime.now());

    if (pickedRange != null) {
      setState(() {
        widget.cycle.startDate = pickedRange.start;
        widget.cycle.endDate = pickedRange.end;
      });
    }
  }

  Widget _buttons() {
    List<Widget> buttons = [];

    buttons.add(FilledButton.icon(
      onPressed: _validToSave() ? _saveBudgetCycle : null,
      label: Text('Guardar'),
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
    ));
    if (!widget.input) {
      buttons.add(FilledButton.icon(
        onPressed: _validToSave() ? _processCycle : null,
        style: FilledButton.styleFrom(
            backgroundColor: _validToSave() ? Colors.indigo : Colors.white),
        label: Text('Procesar'),
        icon: Icon(
          Icons.double_arrow_rounded,
          color: Colors.white,
        ),
      ));
    }

    return Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        verticalDirection: VerticalDirection.up,
        children: buttons);
  }

  Widget _buttonsAdditional() {
    List<Widget> buttons = [];

    if (!widget.input) {
      buttons.add(FilledButton.icon(
        onPressed: _validToSave() ? _createPlan : null,
        style: FilledButton.styleFrom(
            backgroundColor: _validToSave() ? Colors.green : Colors.white),
        label: Text('Crear Plan'),
        icon: Icon(
          Icons.place,
          color: Colors.white,
        ),
      ));

      buttons.add(FilledButton.icon(
        onPressed: _validToSave() ? _delete : null,
        style: FilledButton.styleFrom(
            backgroundColor: _validToSave() ? Colors.red : Colors.white),
        label: Text('Eliminar'),
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ));
    }
    return Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        verticalDirection: VerticalDirection.up,
        children: buttons);
  }

  _validToSave() {
    var description = widget.cycle.description.trim().isNotEmpty;
    return !saving && (description);
  }

  _saveBudgetCycle() async {
    setState(() => saving = true);
    widget.cycle.enabled = widget.selectedToggle[0] == true;
    widget.cycle.mongoId = await CycleService().save(widget.cycle);
    setState(() => saving = false);
    if (context.mounted) {
      BudgetProvider provider =
          Provider.of<BudgetProvider>(context, listen: false);
      await provider.searchCycles(true);
      if (widget.input && context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  _processCycle() async {
    setState(() => saving = true);
    await ExpenseService().updateCycle(widget.cycle);
    setState(() => saving = false);
  }

  _delete() async {
    setState(() => saving = true);
    await widget.delete!(widget.cycle);
    setState(() => saving = false);
  }

  _createPlan() async {
    setState(() => saving = true);
    for (var plan in widget.plan) {
      await PlanCycleService().save(PlanCycle(
          fuid: MemoryStorage.instance.userData?.fuid ?? "",
          expenses: [],
          clasification: plan.clasification,
          category: plan.category,
          initialValue: plan.value,
          actualValue: plan.value,
          cycleId: widget.cycle.id,
          planId: plan.id,
          valid: widget.cycle.enabled));
    }
    await widget.update!(widget.cycle);

    setState(() => saving = false);
  }
}
