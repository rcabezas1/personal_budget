import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/service/providers/budget_provider.dart';
import 'package:personal_budget/view/inputs/formats.dart';
import 'package:personal_budget/view/layout/layout.dart';
import 'package:personal_budget/view/layout/menu_list.dart';
import 'package:personal_budget/view/loaders/screen_loader.dart';
import 'package:personal_budget/view/plan/plan_cycle_card.dart';
import 'package:provider/provider.dart';

class PlanCycleList extends StatefulWidget {
  const PlanCycleList({super.key});

  @override
  State<PlanCycleList> createState() => _PlanCycleListState();
}

class _PlanCycleListState extends State<PlanCycleList> {
  bool showblur = false;
  bool _loading = false;
  Widget? alertWidget;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
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
      id: MenuList.plan,
      title: MenuList.plan.menuTitle,
      titleWidget: _progress(),
      searchBar: true,
      searchController: _searchController,
      body: GFFloatingWidget(
        showBlurness: showblur,
        verticalPosition: 80,
        body: Consumer<BudgetProvider>(
            builder: (context, provider, child) => RefreshIndicator(
                onRefresh: _searchCycles,
                child:
                    _loading ? const ScreenLoader() : _listBuilder(provider))),
        child: alertWidget,
      ),
    );
  }

  Widget _progress() {
    return Consumer<BudgetProvider>(
        builder: (context, provider, child) => GFProgressBar(
            percentage: _getPercentage(provider),
            lineHeight: 40,
            backgroundColor: _getPercentageColor(provider),
            progressBarColor: GFColors.INFO,
            child: Column(
              children: [
                const SizedBox.square(
                  dimension: 2,
                ),
                Text(
                  '\$${currencyFormat.format(_getActual(provider))}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: GFColors.LIGHT,
                      fontSize: 20),
                ),
                Text(
                  'Presupuesto: \$${currencyFormat.format(_getInitial(provider))}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: GFColors.LIGHT,
                      fontSize: 12),
                ),
              ],
            )));
  }

  double _getPercentage(BudgetProvider provider) {
    double initial = 0;
    double actual = 0;
    provider.getPlanCycle().forEach((element) {
      initial = initial + (element.initialValue ?? 0);
      actual = actual + (element.actualValue ?? 0);
    });

    var percentage = actual / initial;
    if (percentage >= 0) {
      return percentage;
    }
    return 0;
  }

  _getPercentageColor(BudgetProvider provider) {
    double actual = 0;
    provider.getPlanCycle().forEach((element) {
      actual = actual + (element.actualValue ?? 0);
    });
    if (actual < 0) {
      return GFColors.DANGER;
    }
    return GFColors.DARK;
  }

  _getActual(BudgetProvider provider) {
    double actual = 0;
    provider.getPlanCycle().forEach((element) {
      actual = actual + (element.actualValue ?? 0);
    });
    return actual;
  }

  _getInitial(BudgetProvider provider) {
    double initial = 0;
    provider.getPlanCycle().forEach((element) {
      initial = initial + (element.initialValue ?? 0);
    });
    return initial;
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

  Future<void> _performSearch() async {
    setState(() {
      _loading = true;
    });
    BudgetProvider provider =
        Provider.of<BudgetProvider>(context, listen: false);
    setState(() {
      if (_searchController.text.isEmpty) {
        provider.defaultSortPlanCycle();
      } else {
        provider.sortPlanCycles(_searchController.text.toLowerCase());
      }
      _loading = false;
    });
  }
}
