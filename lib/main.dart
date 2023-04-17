import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/budget/budget_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:personal_budget/budget/budget_list.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(ChangeNotifierProvider(
      create: (context) => BudgetProvider(), child: const MainApp()));
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
      home: BudgetList(),
    );
  }
}
