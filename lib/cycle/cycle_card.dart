import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/plan/plan.dart';
import 'package:personal_budget/plan/plan_cycle.dart';

import 'package:personal_budget/providers/budget_provider.dart';
import 'package:personal_budget/cycle/budget_cycle.dart';
import 'package:personal_budget/loaders/avatar_loader.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:personal_budget/service/cycle_service.dart';
import 'package:personal_budget/service/plan_cycle_service.dart';
import 'package:provider/provider.dart';

import '../formats.dart';

class CycleCard extends StatefulWidget {
  const CycleCard(
      {Key? key,
      required this.cycle,
      required this.input,
      required this.plan,
      this.delete,
      this.update})
      : super(key: key);

  final BudgetCycle cycle;
  final bool input;
  final List<Plan> plan;
  final AsyncValueSetter<BudgetCycle>? delete;
  final AsyncValueSetter<BudgetCycle>? update;

  @override
  CycleCardState createState() => CycleCardState();
}

class CycleCardState extends State<CycleCard> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return GFCard(
        title: GFListTile(
          avatar: AvatarLoader(saving: saving, avatar: "cycle"),
          subTitle: _inputDescription(),
          title: _toggleActive(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_inputDate()],
        ),
        buttonBar: GFButtonBar(
            runAlignment: WrapAlignment.end,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: _buttons()));
  }

  _inputDescription() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Descripcion',
      ),
      initialValue: widget.cycle.description,
      onChanged: _setDescription,
    );
  }

  _setDescription(String description) {
    setState(() {
      widget.cycle.description = description.trim();
    });
  }

  _inputDate() {
    return GFButton(
      onPressed: _datePicker,
      shape: GFButtonShape.pills,
      text:
          '${dateFormat.format(widget.cycle.startDate)}  ${dateFormat.format(widget.cycle.endDate)} ',
    );
  }

  _toggleActive() {
    return GFToggle(
        onChanged: (val) {
          setState(() => widget.cycle.enabled = val ?? false);
        },
        value: widget.cycle.enabled);
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

  List<Widget> _buttons() {
    List<Widget> buttons = [];

    buttons.add(GFButton(
      onPressed: _validToSave() ? _saveBudgetCycle : null,
      text: 'Guardar',
      icon: Icon(
        Icons.save,
        color: _validToSave() ? GFColors.PRIMARY : GFColors.LIGHT,
      ),
      type: GFButtonType.outline2x,
    ));
    if (!widget.input) {
      buttons.add(GFButton(
        onPressed: _validToSave() ? _processCycle : null,
        color: _validToSave() ? GFColors.FOCUS : GFColors.LIGHT,
        text: 'Procesar',
        icon: Icon(
          Icons.double_arrow_rounded,
          color: _validToSave() ? GFColors.FOCUS : GFColors.LIGHT,
        ),
        type: GFButtonType.outline2x,
      ));

      buttons.add(GFButton(
        onPressed: _validToSave() ? _createPlan : null,
        color: _validToSave() ? GFColors.INFO : GFColors.LIGHT,
        text: 'Crear Plan',
        icon: Icon(
          Icons.place,
          color: _validToSave() ? GFColors.INFO : GFColors.LIGHT,
        ),
        type: GFButtonType.outline2x,
      ));

      buttons.add(GFButton(
        onPressed: _validToSave() ? _delete : null,
        color: _validToSave() ? GFColors.DANGER : GFColors.LIGHT,
        text: 'Eliminar',
        icon: Icon(
          Icons.delete,
          color: _validToSave() ? GFColors.DANGER : GFColors.LIGHT,
        ),
        type: GFButtonType.outline2x,
      ));
    }
    return buttons;
  }

  _validToSave() {
    var description = widget.cycle.description.trim().isNotEmpty;
    return !saving && (description);
  }

  _saveBudgetCycle() async {
    setState(() => saving = true);
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
