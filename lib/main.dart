import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:personal_budget/expenses/expense.dart';
import 'package:personal_budget/expenses/expense_list.dart';
import 'package:personal_budget/providers/budget_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:personal_budget/providers/user_provider.dart';
import 'package:personal_budget/user/login_view.dart';
import 'package:personal_budget/user/user_service.dart';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  BudgetProvider budgetProvider = BudgetProvider();
  budgetProvider.smsAvailable = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
  await budgetProvider.searchPlanCycle(true);
  await budgetProvider.searchPlan(true);
  UserProvider userProvider = UserProvider(UserService());
  userProvider.checkUserAuthenticated();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => budgetProvider),
    ChangeNotifierProvider(create: (context) => userProvider)
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es', 'CO'), Locale('en')],
      restorationScopeId: "personal_budget",
      home: FirebaseAuth.instance.currentUser != null
          ? const ExpensesList()
          : const LoginView(),
    );
  }
}
