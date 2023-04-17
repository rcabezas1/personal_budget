import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:personal_budget/budget/budget_list.dart';

import 'package:personal_budget/service/mongo_service.dart';
import 'package:provider/provider.dart';

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
  var currencyFormatter =
      CurrencyTextInputFormatter(locale: "es-CO", symbol: "", decimalDigits: 0);

  final currencyFormat = NumberFormat.currency(
    symbol: "",
    decimalDigits: 0,
    locale: "es-CO",
  );

  final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");

  @override
  void initState() {
    currencyFormatter = CurrencyTextInputFormatter(
        locale: "es-CO", symbol: "", decimalDigits: 0);
    super.initState();
  }

  bool showblur = false;
  Widget? alertWidget;

  @override
  Widget build(BuildContext context) {
    return GFCard(
        title: GFListTile(
          avatar: saving ? _avatarLoader() : _avatar(),
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

  GFAvatar _avatar() {
    return GFAvatar(
      backgroundColor: GFColors.LIGHT,
      backgroundImage:
          AssetImage('assets/${widget.message.type?.nameType}.png'),
    );
  }

  GFLoader _avatarLoader() {
    return const GFLoader(
      type: GFLoaderType.circle,
      loaderColorOne: GFColors.INFO,
      loaderColorTwo: GFColors.PRIMARY,
      loaderColorThree: GFColors.INFO,
    );
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
    return widgets;
  }

  _validToSave() {
    var category = widget.message.category?.trim().isNotEmpty ?? false;
    var description = widget.message.description?.trim().isNotEmpty ?? false;
    var commerce = widget.message.commerce?.trim().isNotEmpty ?? false;
    var value = (widget.message.value ?? 0) > 0;

    return !saving && (category && description && commerce && value);
  }

  _deleteBudgetMessage() async {
    setState(() => saving = true);
    await widget.delete!(widget.message);
    setState(() => saving = false);
  }

  _saveBudgetMessage() async {
    setState(() => saving = true);
    await MongoService().saveBudgetMessage(widget.message);
    setState(() => saving = false);

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
    return TextFormField(
      inputFormatters: [currencyFormatter],
      initialValue: _valueInitial(),
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: GFSize.MEDIUM),
      decoration: const InputDecoration(
          hintText: 'Valor', hintStyle: TextStyle(fontSize: GFSize.MEDIUM)),
      onChanged: _setValue,
    );
  }

  _valueInitial() {
    if (widget.message.value != null) {
      return currencyFormatter.format('${widget.message.value!.toInt()}');
    }
    return "";
  }

  _textValue() {
    return Text(
      '\$${currencyFormat.format(widget.message.value)}',
      style: const TextStyle(fontSize: GFSize.MEDIUM),
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

  _setValue(String value) {
    setState(() {
      if (currencyFormatter.getUnformattedValue().isNaN) {
        widget.message.value = null;
      } else {
        widget.message.value =
            currencyFormatter.getUnformattedValue().toDouble();
      }
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
