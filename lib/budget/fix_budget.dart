import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/budget/budget_list.dart';
import 'package:personal_budget/budget/budget_message.dart';
import 'package:personal_budget/inputs/input_currency.dart';
import '../formats.dart';
import '../inputs/text_currency.dart';
import '../service/mongo_budget_service.dart';
import 'budget_type.dart';
import '../loaders/avatar_loader.dart';

class FixBudget extends StatefulWidget {
  const FixBudget({Key? key, required this.budget}) : super(key: key);

  final BudgetMessage budget;

  @override
  FixBudgetState createState() => FixBudgetState();
}

class FixBudgetState extends State<FixBudget> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          title: const Text('Ajustar valor'),
          backgroundColor: GFColors.PRIMARY,
        ),
        body: SingleChildScrollView(
          restorationId: "fix_budget",
          child: GFCard(
              title: GFListTile(
                avatar: AvatarLoader(
                    saving: saving, avatar: widget.budget.type?.nameType ?? ''),
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
                    value: widget.budget.initialValue,
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
    await MongoBudgetService().save(widget.budget);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BudgetList()),
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
      value: widget.budget.value,
      setValue: _setValue,
      hintText: "Ajuste Valor",
    );
  }

  Future<void> _setValue(double? value) async {
    setState(() {
      widget.budget.value = value;
    });
  }

  _textCommerce() {
    return Text(widget.budget.commerce ?? "");
  }

  _textDescription() {
    return Text('${widget.budget.description}',
        style: const TextStyle(fontSize: GFSize.SMALL));
  }

  _textDate() {
    return GFButton(
      onPressed: null,
      shape: GFButtonShape.pills,
      text: dateFormat.format(widget.budget.date!),
    );
  }
}
