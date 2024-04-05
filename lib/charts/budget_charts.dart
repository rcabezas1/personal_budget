import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/layout/layout.dart';
import 'package:personal_budget/storage/memory_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../layout/menu_list.dart';

class BudgetCharts extends StatefulWidget {
  const BudgetCharts({Key? key}) : super(key: key);

  @override
  State<BudgetCharts> createState() => _BudgetChartsState();
}

class _BudgetChartsState extends State<BudgetCharts> {
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void initState() {
    super.initState();
    controller.loadRequest(Uri.parse(
        MemoryStorage.instance.userData?.dashboard ?? dotenv.get("CHARTS")));
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      id: MenuList.charts,
      title: MenuList.charts.menuTitle,
      body: WebViewWidget(controller: controller),
    );
  }
}
