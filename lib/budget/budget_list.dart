import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_budget/budget/budget_message.dart';
import 'package:personal_budget/budget/add_budget.dart';
import 'package:provider/provider.dart';

import '../budget/budget_card.dart';
import '../charts/budget_charts.dart';
import '../formats.dart';
import '../loaders/screen_loader.dart';
import '../service/mongo_budget_service.dart';
import 'budget_provider.dart';

class BudgetList extends StatefulWidget {
  const BudgetList({Key? key}) : super(key: key);

  @override
  State<BudgetList> createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  bool _loading = true;

  Widget? alertWidget;
  bool showblur = false;

  @override
  void initState() {
    _searchMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: GFColors.PRIMARY,
        title: const Text('Lista de Gastos'),
        actions: [
          GFIconButton(
            onPressed: _showCharts,
            type: GFButtonType.transparent,
            icon: const Icon(
              Icons.bar_chart,
              color: GFColors.LIGHT,
            ),
          ),
          GFIconButton(
            onPressed: _addBudgetMessage,
            type: GFButtonType.transparent,
            icon: const Icon(
              Icons.add,
              color: GFColors.LIGHT,
            ),
          )
        ],
      ),
      body: GFFloatingWidget(
        showBlurness: showblur,
        verticalPosition: 80,
        body: Consumer<BudgetProvider>(
            builder: (context, provider, child) => RefreshIndicator(
                onRefresh: _searchMessages,
                child:
                    _loading ? const ScreenLoader() : _listBuilder(provider))),
        child: alertWidget,
      ),
    );
  }

  _listBuilder(BudgetProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.countMessage,
      itemBuilder: (BuildContext context, int i) {
        var message = provider.getMessage(i);
        return BudgetCard(
          message: message,
          input: false,
          delete: _deleteBudget,
        );
      },
    );
  }

  Future<void> _deleteBudget(BudgetMessage message) async {
    setState(() {
      showblur = true;
      alertWidget = GFAlert(
        type: GFAlertType.rounded,
        title: "Está seguro de eliminar?",
        content:
            '${message.commerce} \$${currencyFormat.format(message.value)}',
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

  _doDelete(BudgetMessage message) async {
    await MongoBudgetService()
        .delete(message.id)
        .then((value) => _updateCard(message));
    setState(() {
      alertWidget = null;
      showblur = false;
    });
  }

  Future<void> _updateCard(BudgetMessage newMessage) async {
    await _searchMessages();
  }

  _addBudgetMessage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBudget()),
    );
  }

  _showCharts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BudgetCharts()),
    );
  }

  Future<void> _searchMessages() async {
    setState(() {
      _loading = true;
    });
    var permission = await Permission.sms.status;
    if (permission.isGranted && context.mounted) {
      BudgetProvider provider =
          Provider.of<BudgetProvider>(context, listen: false);
      provider.searchMessages().then((value) => setState(() {
            _loading = false;
          }));
    } else {
      await Permission.sms.request();
    }
  }
}
