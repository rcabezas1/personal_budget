import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:personal_budget/budget/budget_list.dart';
import 'package:personal_budget/budget/fix_budget.dart';
import 'package:personal_budget/inputs/text_currency.dart';
import 'package:personal_budget/loaders/avatar_loader.dart';
import 'package:personal_budget/service/mongo_budget_service.dart';
import 'package:provider/provider.dart';

import '../formats.dart';
import '../inputs/input_currency.dart';
import 'budget_message.dart';
import 'budget_provider.dart';
import 'budget_type.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard(
      {super.key, required this.message, required this.input, this.delete});

  final BudgetMessage message;
  final bool input;
  final AsyncValueSetter<BudgetMessage>? delete;

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
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
              saving: saving, avatar: widget.message.type?.nameType ?? ''),
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
      onPressed: _validToSave() ? _saveBudgetMessage : null,
      text: 'Guardar',
      icon: Icon(
        Icons.save,
        color: _validToSave() ? GFColors.PRIMARY : GFColors.LIGHT,
      ),
      type: GFButtonType.outline2x,
    ));
    if (!widget.input && widget.message.type == BudgetType.cash) {
      widgets.add(GFButton(
        onPressed: saving ? null : _deleteBudgetMessage,
        color: GFColors.DANGER,
        icon: Icon(
          Icons.delete,
          color: saving ? GFColors.LIGHT : GFColors.DANGER,
        ),
        type: GFButtonType.outline2x,
        text: 'Eliminar',
      ));
    }
    if (!widget.input && widget.message.type != BudgetType.cash) {
      widgets.add(GFButton(
        onPressed: saving ? null : _fixBudgetMessage,
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
    var category = widget.message.category?.trim().isNotEmpty ?? false;
    var description = widget.message.description?.trim().isNotEmpty ?? false;
    var commerce = widget.message.commerce?.trim().isNotEmpty ?? false;
    var value =
        widget.message.value != null && (widget.message.value ?? 0) >= 0;

    return !saving && (category && description && commerce && value);
  }

  _deleteBudgetMessage() async {
    setState(() => saving = true);
    await widget.delete!(widget.message);
    setState(() => saving = false);
  }

  _fixBudgetMessage() async {
    setState(() => saving = true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FixBudget(budget: widget.message)));
    setState(() => saving = false);
  }

  _saveBudgetMessage() async {
    setState(() => saving = true);
    await MongoBudgetService().save(widget.message);

    if (widget.input && context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BudgetList()),
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
      initialValue: widget.message.description,
      onChanged: _setCommerce,
    );
  }

  _textCommerce() {
    return Text(widget.message.commerce ?? "");
  }

  _inputCategory() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Categoria',
      ),
      initialValue: widget.message.category,
      onChanged: _setCategory,
    );
  }

  _inputValue() {
    return InputCurrency(
      value: widget.message.value,
      setValue: _setValue,
      hintText: "Valor",
    );
  }

  _textValue() {
    final List<Widget> values = [TextCurrency(value: widget.message.value)];
    if (widget.message.value != widget.message.initialValue) {
      values.add(TextCurrency(
        value: widget.message.initialValue,
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
      initialValue: widget.message.description,
      onChanged: _setDescription,
    );
  }

  _setCommerce(String commerce) {
    setState(() {
      widget.message.commerce = commerce.trim();
    });
  }

  Future<void> _setValue(double? value) async {
    setState(() {
      widget.message.value = value;
    });
  }

  _setCategory(String category) {
    setState(() {
      widget.message.category = category.trim();
    });
  }

  _setDescription(String description) {
    setState(() {
      widget.message.description = description.trim();
    });
  }

  _inputDate() {
    return GFButton(
      onPressed: widget.message.type == BudgetType.cash ? _datePicker : null,
      shape: GFButtonShape.pills,
      text: dateFormat.format(widget.message.date!),
    );
  }

  _datePicker() async {
    DateTime currentDate = widget.message.date ?? DateTime.now();
    DateTime? pickedDate = await showOmniDateTimePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate.subtract(const Duration(days: 100)),
        lastDate: currentDate.add(const Duration(days: 30)));
    if (pickedDate != null) {
      setState(() => widget.message.date = pickedDate);
    }
  }
}
