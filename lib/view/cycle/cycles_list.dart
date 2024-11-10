import 'package:flutter/material.dart';
import 'package:personal_budget/service/providers/budget_provider.dart';
import 'package:personal_budget/view/cycle/add_cycle.dart';
import 'package:personal_budget/model/cycle/budget_cycle.dart';
import 'package:personal_budget/view/cycle/cycle_card.dart';
import 'package:personal_budget/view/inputs/formats.dart';
import 'package:personal_budget/view/layout/layout.dart';
import 'package:personal_budget/service/cycle_service.dart';
import 'package:personal_budget/view/layout/menu_list.dart';
import 'package:personal_budget/view/loaders/screen_loader.dart';
import 'package:provider/provider.dart';

class CyclesList extends StatefulWidget {
  const CyclesList({super.key});

  @override
  State<CyclesList> createState() => _CyclesListState();
}

class _CyclesListState extends State<CyclesList> {
  bool showblur = false;
  bool _loading = false;
  Widget? alertWidget;

  @override
  Widget build(BuildContext context) {
    return Layout(
      id: MenuList.cycle,
      title: MenuList.cycle.menuTitle,
      actions: [
        IconButton(
          onPressed: _addCycle,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        )
      ],
      body: Consumer<BudgetProvider>(
          builder: (context, provider, child) => RefreshIndicator(
              onRefresh: _searchCycles,
              child: _loading ? const ScreenLoader() : _listBuilder(provider))),
      //child: alertWidget,
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
          plan: provider.getPlan(),
          delete: _delete,
          update: _update,
        );
      },
    );
  }

  Future<void> _searchCycles() async {
    setState(() {
      _loading = true;
    });
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    provider.searchCycles(true).then((value) => setState(() {
          _loading = false;
        }));
  }

  _addCycle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCycles()),
    );
  }

  Future<void> _delete(BudgetCycle message) async => showDialog<BudgetCycle>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Está seguro de eliminar?"),
          content: Text(
            '${message.description} \nVigencia: ${dateFormat.format(message.startDate)} -  ${dateFormat.format(message.endDate)}',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.pop(context, message),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, message);
                _doDelete(message);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

  _doDelete(BudgetCycle message) async {
    await CycleService().delete(message.id).then((value) => _searchCycles());
    setState(() {
      alertWidget = null;
      showblur = false;
    });
  }

  Future<void> _update(BudgetCycle message) async {
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    provider.searchPlanCycle(true).then((value) => setState(() {
          _loading = false;
        }));
  }
}
