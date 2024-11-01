import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:personal_budget/model/expenses/expense_type.dart';
import 'package:personal_budget/service/providers/budget_provider.dart';
import 'package:personal_budget/view/expenses/expense_list.dart';
import 'package:personal_budget/view/expenses/fix_expense.dart';
import 'package:personal_budget/view/inputs/text_currency.dart';
import 'package:personal_budget/model/plan/plan_cycle.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:personal_budget/service/storage/memory_storage.dart';
import 'package:personal_budget/view/loaders/avatar_loader.dart';
import 'package:provider/provider.dart';

import 'package:personal_budget/view/inputs/formats.dart';
import 'package:personal_budget/view/inputs/input_currency.dart';
import 'package:personal_budget/service/plan_cycle_service.dart';
import 'package:personal_budget/model/expenses/expense.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard(
      {super.key, required this.expense, required this.input, this.delete});

  final Expense expense;
  final bool input;
  final AsyncValueSetter<Expense>? delete;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  bool saving = false;
  bool validPlanCycle = false;

  @override
  void initState() {
    super.initState();
  }

  bool showblur = false;
  Widget? alertWidget;
  PlanCycle? selectedPlan;

  @override
  Widget build(BuildContext context) {
    _initSelectedProvider();
    return Card(
        /*title: GFListTile(
          avatar: AvatarLoader(
              saving: saving, avatar: widget.expense.type?.nameType ?? ''),
          title: widget.input ? _inputCommerce() : _textCommerce(),
          subTitle: _inputDate(),
          description: widget.input ? _inputValue() : _textValue(),
        ),*/
        child: ListTile(
      leading: AvatarLoader(
          saving: saving, avatar: widget.expense.type?.nameType ?? ''),
      title: widget.input ? _inputCommerce() : _textCommerce(),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: _getInputs(),
      ),
    )

        /*buttonBar: GFButtonBar(
            runAlignment: WrapAlignment.end,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: _buttons())*/
        );
  }

  List<Widget> _getInputs() {
    if (!validPlanCycle) {
      return [
        _inputDate(),
        (widget.input ? _inputValue() : _textValue()),
        _inputDescription(),
        _inputCategory(),
        Row(children: _buttons())
      ];
    }
    return [
      _inputDate(),
      (widget.input ? _inputValue() : _textValue()),
      _inputDescription(),
      const SizedBox(height: 10),
      _inputPlan(),
      Row(children: _buttons())
    ];
  }

  _initSelectedProvider() {
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    validPlanCycle = provider.getPlanCycle().isNotEmpty;
    selectedPlan = provider.getPlanCycle().firstWhere(
          (element) => element.id == widget.expense.plan,
          orElse: () => PlanCycle(fuid: "", expenses: []),
        );
  }

  List<Widget> _buttons() {
    List<Widget> widgets = <Widget>[];

    widgets.add(TextButton(
      onPressed: _validToSave() ? _saveExpense : null,
      child: Text('Guardar'),
      /*icon: Icon(
        Icons.save,
        color: _validToSave() ? GFColors.PRIMARY : GFColors.LIGHT,
      ),
      type: GFButtonType.outline2x,*/
    ));
    if (!widget.input && widget.expense.type == ExpenseType.cash) {
      widgets.add(TextButton(
        onPressed: saving ? null : _deleteExpense,
        /*color: GFColors.DANGER,
        icon: Icon(
          Icons.delete,
          color: saving ? GFColors.LIGHT : GFColors.DANGER,
        ),
        type: GFButtonType.outline2x,*/
        child: Text('Eliminar'),
      ));
    }
    if (!widget.input && widget.expense.type != ExpenseType.cash) {
      widgets.add(TextButton(
        onPressed: saving ? null : _fixExpenseMessage,
        /*color: GFColors.FOCUS,
        icon: Icon(
          Icons.double_arrow_rounded,
          color: saving ? GFColors.LIGHT : GFColors.FOCUS,
        ),
        type: GFButtonType.outline2x,*/
        child: Text('Ajustar'),
      ));
    }
    return widgets;
  }

  _validToSave() {
    if (validPlanCycle) {
      widget.expense.category = selectedPlan?.category ?? "";
    }
    var category = widget.expense.category?.trim().isNotEmpty ?? false;
    var description = widget.expense.description?.trim().isNotEmpty ?? false;
    var commerce = widget.expense.commerce?.trim().isNotEmpty ?? false;
    var value =
        widget.expense.value != null && (widget.expense.value ?? 0) >= 0;

    return !saving && (category && description && commerce && value);
  }

  _deleteExpense() async {
    setState(() => saving = true);
    await widget.delete!(widget.expense);
    setState(() => saving = false);
  }

  _fixExpenseMessage() async {
    setState(() => saving = true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FixExpense(expense: widget.expense)));
    setState(() => saving = false);
  }

  _saveExpense() async {
    setState(() => saving = true);
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    widget.expense.fuid = MemoryStorage.instance.userData?.fuid ?? "";
    await ExpenseService().save(widget.expense);
    await PlanCycleService().updateActualState(widget.expense);
    await provider.searchPlanCycle(true);
    if (widget.input && context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ExpensesList()),
          (route) => false);
    } else {
      provider.updateList();
    }

    setState(() => saving = false);
  }

  _inputCommerce() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Comercio',
      ),
      initialValue: widget.expense.description,
      onChanged: _setCommerce,
    );
  }

  _textCommerce() {
    return Text(widget.expense.commerce ?? "");
  }

  _inputCategory() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Categoria',
      ),
      initialValue: widget.expense.category,
      onChanged: _setCategory,
    );
  }

  void _setCategory(String category) {
    setState(() {
      widget.expense.category = category.trim();
    });
  }

  _inputPlan() {
    Provider.of<BudgetProvider>(context, listen: false);
    return DropdownSearch<PlanCycle>(
      itemAsString: _itemStringValue,
      items: _returnedItems,
      compareFn: _comparePlan,
      filterFn: _itemFilter,
      selectedItem: selectedPlan,
      popupProps: const PopupProps.dialog(showSearchBox: true),
      onChanged: _setPlan,
    );
  }

  String _itemStringValue(PlanCycle plan) {
    if (plan.id != null) {
      return '${plan.category!} - Disponible: \$${currencyFormat.format(plan.actualValue ?? 0)}';
    }
    return "";
  }

  bool _comparePlan(PlanCycle? item1, PlanCycle? item2) {
    if (item1 != null && item2 != null) {
      return item1.category!.compareTo(item2.category!) > 0;
    }
    return false;
  }

  bool _itemFilter(PlanCycle plan, String filter) {
    return plan.category!.toLowerCase().contains(filter.toLowerCase().trim());
  }

  _inputValue() {
    return InputCurrency(
      value: widget.expense.value,
      setValue: _setValue,
      hintText: "Valor",
    );
  }

  _textValue() {
    final List<Widget> values = [TextCurrency(value: widget.expense.value!)];
    if (widget.expense.value! != widget.expense.initialValue!) {
      values.add(TextCurrency(
        value: widget.expense.initialValue!,
        size: 15,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values,
    );
  }

  _inputDescription() {
    return TextFormField(
      restorationId: "desc${widget.expense.id}",
      decoration: const InputDecoration(
        hintText: 'Descripcion',
      ),
      initialValue: widget.expense.description,
      onChanged: _setDescription,
    );
  }

  _setCommerce(String commerce) {
    setState(() {
      widget.expense.commerce = commerce.trim();
    });
  }

  Future<void> _setValue(double? value) async {
    setState(() {
      widget.expense.value = value;
    });
  }

  void _setPlan(PlanCycle? newPlan) {
    setState(() {
      if (newPlan != null) {
        selectedPlan = newPlan;
        widget.expense.plan = newPlan.id;
      }
    });
  }

  _setDescription(String description) {
    setState(() {
      widget.expense.description = description.trim();
    });
  }

  _inputDate() {
    return TextButton(
      onPressed: widget.expense.type == ExpenseType.cash ? _datePicker : null,
      child: Text(dateFormat.format(widget.expense.date!)),
    );
  }

  _datePicker() async {
    DateTime currentDate = widget.expense.date ?? DateTime.now();
    DateTime? pickedDate = await showOmniDateTimePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate.subtract(const Duration(days: 100)),
        lastDate: currentDate.add(const Duration(days: 30)));
    if (pickedDate != null) {
      setState(() => widget.expense.date = pickedDate);
    }
  }

  FutureOr<List<PlanCycle>> _returnedItems(
      String filter, LoadProps? loadProps) {
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    return provider.getPlanCycle();
  }
}
