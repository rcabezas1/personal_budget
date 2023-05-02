import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/expenses/expense_list.dart';
import 'package:personal_budget/expenses/expense.dart';
import 'package:personal_budget/inputs/input_currency.dart';
import '../formats.dart';
import '../inputs/text_currency.dart';
import '../service/expense_service.dart';
import 'expense_type.dart';
import '../loaders/avatar_loader.dart';

class FixExpense extends StatefulWidget {
  const FixExpense({Key? key, required this.expense}) : super(key: key);

  final Expense expense;

  @override
  FixExpenseState createState() => FixExpenseState();
}

class FixExpenseState extends State<FixExpense> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          title: const Text('Ajustar valor'),
          backgroundColor: GFColors.PRIMARY,
        ),
        body: SingleChildScrollView(
          restorationId: "fix_expense",
          child: GFCard(
              title: GFListTile(
                avatar: AvatarLoader(
                    saving: saving,
                    avatar: widget.expense.type?.nameType ?? ''),
                title: _textCommerce(),
                description: _textDate(),
                subTitle: _textDescription(),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputLabel('Valor Inicial'),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  TextCurrency(
                    value: widget.expense.initialValue!,
                    size: GFSize.SMALL,
                  ),
                  const SizedBox.square(
                    dimension: 30,
                  ),
                  _inputLabel('Ajuste Valor'),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  _inputValue(),
                ],
              ),
              buttonBar: GFButtonBar(
                  runAlignment: WrapAlignment.end,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: _buttons())),
        ));
  }

  List<Widget> _buttons() {
    return <Widget>[
      GFButton(
        onPressed: !saving ? _saveFixed : null,
        text: 'Guardar',
        icon: Icon(
          Icons.save,
          color: !saving ? GFColors.PRIMARY : GFColors.LIGHT,
        ),
        type: GFButtonType.outline2x,
      )
    ];
  }

  _saveFixed() async {
    setState(() => saving = true);
    await ExpenseService().save(widget.expense);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ExpensesList()),
          (route) => false);
    }
  }

  _inputLabel(String label) {
    return Text(
      label,
    );
  }

  _inputValue() {
    return InputCurrency(
      value: widget.expense.value,
      setValue: _setValue,
      hintText: "Ajuste Valor",
    );
  }

  Future<void> _setValue(double? value) async {
    setState(() {
      widget.expense.value = value;
    });
  }

  _textCommerce() {
    return Text(widget.expense.commerce ?? "");
  }

  _textDescription() {
    return Text('${widget.expense.description}',
        style: const TextStyle(fontSize: GFSize.SMALL));
  }

  _textDate() {
    return GFButton(
      onPressed: null,
      shape: GFButtonShape.pills,
      text: dateFormat.format(widget.expense.date!),
    );
  }
}
