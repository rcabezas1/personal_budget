import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getwidget/getwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    controller.loadRequest(Uri.parse(dotenv.get("CHARTS")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Estadisticas'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
