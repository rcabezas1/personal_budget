import 'package:flutter/material.dart';
import 'package:personal_budget/view/charts/budget_charts.dart';
import 'package:personal_budget/view/cycle/cycles_list.dart';
import 'package:personal_budget/view/expenses/expense_list.dart';
import 'package:personal_budget/view/login/login_view.dart';
import 'package:personal_budget/view/plan/plan_cycle_list.dart';
import 'package:provider/provider.dart';
import 'package:personal_budget/service/providers/user_provider.dart';

import 'menu_list.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({super.key, required this.option, required this.selectedId});

  final MenuList option;

  final MenuList selectedId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(option.menuTitle),
      onTap: () => _navigateTo(context, option),
      selected: selectedId == option,
      selectedTileColor: Colors.blueAccent,
      selectedColor: Colors.white,
    );
  }

  _navigateTo(BuildContext context, MenuList option) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    if (option != MenuList.login && provider.isLogged()) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => _step(option)),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false);
    }
  }

  _step(MenuList option) {
    switch (option) {
      case MenuList.login:
        return const LoginView();
      case MenuList.expense:
        return const ExpensesList();
      case MenuList.charts:
        return const BudgetCharts();
      case MenuList.cycle:
        return const CyclesList();
      case MenuList.plan:
        return const PlanCycleList();
    }
  }
}
