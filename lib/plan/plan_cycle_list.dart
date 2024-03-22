import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/layout/layout.dart';
import 'package:personal_budget/plan/plan_cycle_card.dart';
import 'package:provider/provider.dart';

import '../layout/menu_list.dart';
import '../loaders/screen_loader.dart';
import '../providers/budget_provider.dart';

class PlanCycleList extends StatefulWidget {
  const PlanCycleList({Key? key}) : super(key: key);

  @override
  State<PlanCycleList> createState() => _PlanCycleListState();
}

class _PlanCycleListState extends State<PlanCycleList> {
  bool showblur = false;
  bool _loading = false;
  Widget? alertWidget;

  @override
  Widget build(BuildContext context) {
    return Layout(
        id: MenuList.plan,
        title: MenuList.plan.menuTitle,
        body: GFFloatingWidget(
          showBlurness: showblur,
          verticalPosition: 80,
          body: Consumer<BudgetProvider>(
              builder: (context, provider, child) => RefreshIndicator(
                  onRefresh: _searchCycles,
                  child: _loading
                      ? const ScreenLoader()
                      : _listBuilder(provider))),
          child: alertWidget,
        ));
  }

  _listBuilder(BudgetProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.countPlan,
      itemBuilder: (BuildContext context, int i) {
        var message = provider.getPlanCycleItem(i);
        return PlanCycleCard(cycle: message, plan: provider.getPlan());
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
}
