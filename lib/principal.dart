import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:personal_budget/budget/budget_list.dart';
import 'package:personal_budget/cycle/cycles_list.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  PrincipalState createState() => PrincipalState();
}

class PrincipalState extends State<Principal> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  TabController? _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Gastos",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["Gastos", "Ciclos"],
        icons: const [Icons.home, Icons.currency_exchange_outlined],
        tabBarColor: GFColors.PRIMARY,
        tabIconColor: GFColors.LIGHT,
        tabIconSelectedColor: GFColors.FOCUS,
        tabSelectedColor: GFColors.LIGHT,
        tabSize: 40,
        textStyle: const TextStyle(color: GFColors.LIGHT),
        onTabItemSelected: (int value) {
          setState(() {
            _tabController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const <Widget>[
          BudgetList(),
          CyclesList(),
        ],
      ),
    );
  }
}
