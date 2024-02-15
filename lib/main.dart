import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/expenses/expense_list.dart';
import 'package:personal_budget/providers/budget_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  await dotenv.load();
  BudgetProvider budgetProvider = BudgetProvider();
  budgetProvider.smsAvailable = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  await budgetProvider.searchPlanCycle(true);
  await budgetProvider.searchPlan(true);
  runApp(ChangeNotifierProvider(
      create: (context) => budgetProvider, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('es', 'CO'), Locale('en')],
      restorationScopeId: "personal_budget",
      home: ExpensesList(),
    );
  }
}
