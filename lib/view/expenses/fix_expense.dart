import 'package:flutter/material.dart';
import 'package:personal_budget/model/expenses/expense.dart';
import 'package:personal_budget/model/expenses/expense_type.dart';
import 'package:personal_budget/service/expense_service.dart';
import 'package:personal_budget/view/expenses/expense_list.dart';
import 'package:personal_budget/view/inputs/input_currency.dart';
import 'package:personal_budget/view/loaders/avatar_loader.dart';
import '../inputs/text_currency.dart';

class FixExpense extends StatefulWidget {
  const FixExpense({super.key, required this.expense});

  final Expense expense;

  @override
  FixExpenseState createState() => FixExpenseState();
}

class FixExpenseState extends State<FixExpense> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ajustar valor',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            restorationId: "fix_expense",
            child: Card(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                color: Colors.grey.shade50,
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  titleAlignment: ListTileTitleAlignment.top,
                  title: Row(
                    spacing: 10,
                    children: [
                      AvatarLoader(
                        saving: saving,
                        avatar: widget.expense.type?.nameType ?? '',
                      ),
                      _textCommerce(),
                    ],
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: _getInputs(),
                  ),
                ))));
  }

  List<Widget> _getInputs() {
    return [
      const SizedBox.square(
        dimension: 10,
      ),
      _inputLabel('Valor Inicial'),
      TextCurrency(
        value: widget.expense.initialValue!,
        size: 30,
      ),
      const SizedBox.square(
        dimension: 20,
      ),
      _inputLabel('Ajuste Valor'),
      _inputValue(),
      const SizedBox.square(
        dimension: 20,
      ),
      _buttons()
    ];
  }

  Widget _buttons() {
    return Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.icon(
              onPressed: !saving ? _saveFixed : null, label: Text('Guardar'))
        ]);
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
        style: const TextStyle(fontSize: 10));
  }

  /*_textDate() {
    return GFButton(
      onPressed: null,
      shape: GFButtonShape.pills,
      text: dateFormat.format(widget.expense.date!),
    );
  }*/
}
