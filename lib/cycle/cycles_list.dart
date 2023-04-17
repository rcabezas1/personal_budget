import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/floating_widget/gf_floating_widget.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_alert_type.dart';
import 'package:personal_budget/cycle/add_cycle.dart';
import 'package:personal_budget/cycle/budget_cycle.dart';
import 'package:personal_budget/cycle/cycle_card.dart';
import 'package:personal_budget/service/mongo_cycle_service.dart';
import 'package:provider/provider.dart';

import '../budget/budget_provider.dart';
import '../loaders/screen_loader.dart';

class ListCycles extends StatefulWidget {
  const ListCycles({Key? key}) : super(key: key);

  @override
  State<ListCycles> createState() => _ListCyclesState();
}

class _ListCyclesState extends State<ListCycles> {
  bool showblur = false;
  bool _loading = false;
  Widget? alertWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Lista de ciclos'),
      ),
      body: GFFloatingWidget(
        showBlurness: showblur,
        verticalPosition: 80,
        body: Consumer<BudgetProvider>(
            builder: (context, provider, child) => RefreshIndicator(
                onRefresh: _searcCycles,
                child:
                    _loading ? const ScreenLoader() : _listBuilder(provider))),
        child: alertWidget,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addCycle, child: const Icon(Icons.add_card)),
    );
  }

  _listBuilder(BudgetProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.countCycles,
      itemBuilder: (BuildContext context, int i) {
        var message = provider.getCycles(i);
        return CycleCard(
          cycle: message,
          input: false,
          delete: _delete,
        );
      },
    );
  }

  Future<void> _searcCycles() async {
    setState(() {
      _loading = true;
    });
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    provider.searchCycles().then((value) => setState(() {
          _loading = false;
        }));
  }

  _addCycle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCycles()),
    );
  }

  Future<void> _delete(BudgetCycle message) async {
    setState(() {
      showblur = true;
      alertWidget = GFAlert(
        type: GFAlertType.rounded,
        title: "Está seguro de eliminar?",
        content:
            '${message.description} \nVigencia: ${dateFormat.format(message.startDate)} -  ${dateFormat.format(message.endDate)}',
        bottombar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          GFButton(
            onPressed: () {
              setState(() {
                alertWidget = null;
                showblur = false;
              });
            },
            shape: GFButtonShape.pills,
            text: "Cancelar",
          ),
          const SizedBox(width: 5),
          GFButton(
            onPressed: () {
              _doDelete(message);
            },
            color: GFColors.DANGER,
            shape: GFButtonShape.pills,
            text: "Eliminar",
          )
        ]),
      );
    });
  }

  _doDelete(BudgetCycle message) async {
    await MongoCycleService()
        .delete(message.id)
        .then((value) => _searcCycles());
    setState(() {
      alertWidget = null;
      showblur = false;
    });
  }
}
