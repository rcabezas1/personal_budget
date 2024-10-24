import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:personal_budget/firebase_options.dart';
import 'package:personal_budget/service/providers/budget_provider.dart';
import 'package:personal_budget/service/providers/user_provider.dart';
import 'package:personal_budget/service/storage/memory_storage.dart';
import 'package:personal_budget/service/user_service.dart';
import 'package:personal_budget/view/login/login_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  MemoryStorage.instance.startTimer();
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  UserProvider userProvider = UserProvider(UserService());
  await userProvider.addUserData();
  await userProvider.checkUserAuthenticated();
  BudgetProvider budgetProvider = BudgetProvider();
  budgetProvider.smsAvailable = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
  if (FirebaseAuth.instance.currentUser != null) {
    budgetProvider.searchPlanCycle(true);
    budgetProvider.searchPlan(true);
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => budgetProvider),
    ChangeNotifierProvider(create: (context) => userProvider)
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: localization.localizationsDelegates,
      supportedLocales: const [Locale('es', 'CO'), Locale('en')],
      restorationScopeId: "personal_budget",
      home: const LoginView(),
    );
  }
}
