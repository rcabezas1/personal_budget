import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:intl/intl.dart';

import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:personal_budget/budget/budget_provider.dart';
import 'package:personal_budget/cycle/budget_cycle.dart';
import 'package:personal_budget/loaders/avatar_loader.dart';
import 'package:personal_budget/service/mongo_budget_service.dart';
import 'package:personal_budget/service/mongo_cycle_service.dart';
import 'package:provider/provider.dart';

import '../budget/budget_list.dart';

class CycleCard extends StatefulWidget {
  const CycleCard({Key? key, required this.cycle}) : super(key: key);

  final BudgetCycle cycle;

  @override
  CycleCardState createState() => CycleCardState();
}

class CycleCardState extends State<CycleCard> {
  final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return GFCard(
        title: GFListTile(
          avatar: AvatarLoader(saving: saving, avatar: "cycle"),
          title: _inputDescription(),
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

  _datePicker() async {
    DateTime startDate = widget.cycle.startDate;
    DateTime endDate = widget.cycle.endDate;
    List<DateTime>? pickedRange = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: startDate,
      endInitialDate: endDate,
      barrierDismissible: false,
      startFirstDate: startDate.subtract(const Duration(days: 100)),
      startLastDate: startDate.add(const Duration(days: 100)),
      endFirstDate: endDate.subtract(const Duration(days: 100)),
      endLastDate: endDate.add(const Duration(days: 100)),
    );

    if (pickedRange != null && pickedRange.isNotEmpty) {
      setState(() {
        widget.cycle.startDate = pickedRange.first;
        widget.cycle.endDate = pickedRange.last;
      });
    }
  }

  List<Widget> _buttons() {
    return <Widget>[
      GFButton(
        onPressed: _validToSave() ? _saveBudgetCycle : null,
        text: 'Agregar',
        icon: Icon(
          Icons.save,
          color: _validToSave() ? GFColors.PRIMARY : GFColors.LIGHT,
        ),
        type: GFButtonType.outline2x,
      )
    ];
  }

  _validToSave() {
    var description = widget.cycle.description.trim().isNotEmpty;
    return !saving && (description);
  }

  _saveBudgetCycle() async {
    setState(() => saving = true);
    widget.cycle.mongoId = await MongoCycleService().save(widget.cycle);
    await MongoBudgetService().updateCycle(widget.cycle);
    setState(() => saving = false);

    if (context.mounted) {
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
}
