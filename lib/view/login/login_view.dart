import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:personal_budget/service/providers/budget_provider.dart';
import 'package:personal_budget/service/providers/user_provider.dart';
//import 'package:personal_budget/view/expenses/expense_list.dart';
import 'package:personal_budget/view/layout/layout.dart';
import 'package:personal_budget/view/layout/menu_list.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Layout(
        id: MenuList.login,
        title: "Login",
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage: NetworkImage(FirebaseAuth
                      .instance.currentUser?.photoURL ??
                  "https://ik.imagekit.io/5pf21gxsf/public/control-de-acceso.png"),
            ),
            const SizedBox(height: 40),
            Text(
              FirebaseAuth.instance.currentUser?.displayName ??
                  "Iniciar sesión",
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _singInSignOut(context),
          ],
        ))));
  }

  _signInAndRedirect(BuildContext context) async {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    BudgetProvider budgetProvider =
        Provider.of<BudgetProvider>(context, listen: false);
    await provider.signInWithGoogle();
    await _findUserData(budgetProvider).then((value) => _homeNavigation);
  }

  Widget _singInSignOut(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    if (!provider.isLogged()) {
      return SignInButton(Buttons.Google,
          text: "Ingresar con Google",
          onPressed: () => _signInAndRedirect(context));
    }
    return IconButton(
      color: Colors.pink,
      icon: const Icon(Icons.logout),
      onPressed: () =>
          provider.signout().then((value) => _loginNavigation(context)),
      tooltip: "Desconectarse",
    );
  }

  Future<void> _findUserData(BudgetProvider budgetProvider) async {
    await budgetProvider.searchPlanCycle(true);
    budgetProvider.searchPlan(true);
  }

  _homeNavigation(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false);
  }

  _loginNavigation(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false);
  }
}
