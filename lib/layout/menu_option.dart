import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:personal_budget/plan/plan_cycle_list.dart';
import 'package:personal_budget/user/login_view.dart';

import '../expenses/expense_list.dart';
import '../charts/budget_charts.dart';
import '../cycle/cycles_list.dart';
import 'menu_list.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({Key? key, required this.option, required this.selectedId})
      : super(key: key);

  final MenuList option;

  final MenuList selectedId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(option.menuTitle),
      onTap: () => _navigateTo(context, option),
      selected: selectedId == option,
      selectedTileColor: GFColors.ALT,
      selectedColor: GFColors.LIGHT,
    );
  }

  _navigateTo(BuildContext context, MenuList option) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => _step(option)),
        (route) => false);
  }

  _step(MenuList option) {
    switch (option) {
      case MenuList.login:
        return const LoginView();
      case MenuList.expense:
        return const ExpensesList();
      case MenuList.cycle:
        return const CyclesList();
      case MenuList.charts:
        return const BudgetCharts();
      case MenuList.plan:
        return const PlanCycleList();
      default:
        return const ExpensesList();
    }
  }
}
