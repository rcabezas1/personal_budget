import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_budget/expenses/expense.dart';
import 'package:personal_budget/expenses/add_expense.dart';
import 'package:personal_budget/layout/layout.dart';
import 'package:personal_budget/service/plan_cycle_service.dart';
import 'package:provider/provider.dart';

import 'expense_card.dart';
import '../charts/budget_charts.dart';
import '../formats.dart';
import '../layout/menu_list.dart';
import '../loaders/screen_loader.dart';
import '../service/expense_service.dart';
import '../providers/budget_provider.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  bool _loading = true;

  Widget? alertWidget;
  bool showblur = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchProviderMessages();
    _searchController.addListener(_performSearch);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        id: MenuList.expense,
        title: MenuList.expense.menuTitle,
        searchBar: true,
        searchController: _searchController,
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
            onPressed: _addExpense,
            type: GFButtonType.transparent,
            icon: const Icon(
              Icons.add,
              color: GFColors.LIGHT,
            ),
          )
        ],
        body: GFFloatingWidget(
          showBlurness: showblur,
          verticalPosition: 80,
          body: Consumer<BudgetProvider>(
              builder: (context, provider, child) => RefreshIndicator(
                  onRefresh: _searchProviderMessages,
                  child: _loading
                      ? const ScreenLoader()
                      : _listBuilder(provider))),
          child: alertWidget,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addExpense,
          backgroundColor: GFColors.PRIMARY,
          child: const Icon(Icons.add),
        ));
  }

  _listBuilder(BudgetProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      restorationId: "items",
      itemCount: provider.countMessage,
      itemBuilder: (BuildContext context, int i) {
        var message = provider.getExpense(i);
        return ExpenseCard(
            expense: message, input: false, delete: _deleteExpense);
      },
    );
  }

  Future<void> _deleteExpense(Expense message) async {
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
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
              _doDelete(message, provider);
            },
            color: GFColors.DANGER,
            shape: GFButtonShape.pills,
            text: "Eliminar",
          )
        ]),
      );
    });
  }

  _doDelete(Expense message, BudgetProvider provider) async {
    await ExpenseService()
        .delete(message.id)
        .then((value) => _updateCard(message));
    await PlanCycleService().deleteExpense(message);
    await provider.searchPlanCycle(true);
    setState(() {
      alertWidget = null;
      showblur = false;
    });
  }

  Future<void> _updateCard(Expense newMessage) async {
    await _searchProviderMessages();
  }

  _addExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpense()),
    );
  }

  _showCharts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BudgetCharts()),
    );
  }

  Future<void> _searchProviderMessages() async {
    setState(() {
      _loading = true;
    });
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    if (provider.smsAvailable) {
      var permission = await Permission.sms.status;
      if (permission.isGranted && context.mounted) {
        _searchProvider(provider);
      } else {
        await Permission.sms.request();
      }
    } else {
      _searchProvider(provider);
    }
  }

  _searchProvider(BudgetProvider provider) {
    provider.searchExpenses().then((value) => setState(() {
          _loading = false;
        }));
  }

  Future<void> _performSearch() async {
    setState(() {
      _loading = true;
    });
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    //Necesario por errores de text input form
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      if (_searchController.text.isEmpty) {
        provider.defaultSortExpenses();
      } else {
        provider.sortExpensesSearch(_searchController.text.toLowerCase());
      }
      _loading = false;
    });
  }
}
