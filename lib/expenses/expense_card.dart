import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:personal_budget/expenses/expense_list.dart';
import 'package:personal_budget/expenses/fix_expense.dart';
import 'package:personal_budget/inputs/text_currency.dart';
import 'package:personal_budget/loaders/avatar_loader.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:provider/provider.dart';

import '../formats.dart';
import '../inputs/input_currency.dart';
import 'expense.dart';
import '../providers/budget_provider.dart';
import 'expense_type.dart';

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

  @override
  void initState() {
    super.initState();
  }

  bool showblur = false;
  Widget? alertWidget;

  @override
  Widget build(BuildContext context) {
    return GFCard(
        title: GFListTile(
          avatar: AvatarLoader(
              saving: saving, avatar: widget.expense.type?.nameType ?? ''),
          title: widget.input ? _inputCommerce() : _textCommerce(),
          subTitle: _inputDate(),
          description: widget.input ? _inputValue() : _textValue(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_inputDescription(), _inputCategory()],
        ),
        buttonBar: GFButtonBar(
            runAlignment: WrapAlignment.end,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: _buttons()));
  }

  List<Widget> _buttons() {
    List<Widget> widgets = <Widget>[];
    widgets.add(GFButton(
      onPressed: _validToSave() ? _saveExpense : null,
      text: 'Guardar',
      icon: Icon(
        Icons.save,
        color: _validToSave() ? GFColors.PRIMARY : GFColors.LIGHT,
      ),
      type: GFButtonType.outline2x,
    ));
    if (!widget.input && widget.expense.type == ExpenseType.cash) {
      widgets.add(GFButton(
        onPressed: saving ? null : _deleteExpense,
        color: GFColors.DANGER,
        icon: Icon(
          Icons.delete,
          color: saving ? GFColors.LIGHT : GFColors.DANGER,
        ),
        type: GFButtonType.outline2x,
        text: 'Eliminar',
      ));
    }
    if (!widget.input && widget.expense.type != ExpenseType.cash) {
      widgets.add(GFButton(
        onPressed: saving ? null : _fixExpenseMessage,
        color: GFColors.FOCUS,
        icon: Icon(
          Icons.double_arrow_rounded,
          color: saving ? GFColors.LIGHT : GFColors.FOCUS,
        ),
        type: GFButtonType.outline2x,
        text: 'Ajustar',
      ));
    }
    return widgets;
  }

  _validToSave() {
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
    await ExpenseService().save(widget.expense);

    if (widget.input && context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ExpensesList()),
          (route) => false);
    } else {
      BudgetProvider provider =
          Provider.of<BudgetProvider>(context, listen: false);
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

  _inputValue() {
    return InputCurrency(
      value: widget.expense.value,
      setValue: _setValue,
      hintText: "Valor",
    );
  }

  _textValue() {
    final List<Widget> values = [TextCurrency(value: widget.expense.value!)];
    if (widget.expense.value != widget.expense.initialValue) {
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

  _setCategory(String category) {
    setState(() {
      widget.expense.category = category.trim();
    });
  }

  _setDescription(String description) {
    setState(() {
      widget.expense.description = description.trim();
    });
  }

  _inputDate() {
    return GFButton(
      onPressed: widget.expense.type == ExpenseType.cash ? _datePicker : null,
      shape: GFButtonShape.pills,
      text: dateFormat.format(widget.expense.date!),
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
}
