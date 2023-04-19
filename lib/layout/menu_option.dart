import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';

import '../budget/budget_list.dart';
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
      case MenuList.budget:
        return const BudgetList();
      case MenuList.cycle:
        return const CyclesList();
      case MenuList.charts:
        return const BudgetCharts();
      default:
        return const BudgetList();
    }
  }
}
