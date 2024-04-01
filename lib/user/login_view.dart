import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/expenses/expense_list.dart';
import 'package:personal_budget/layout/layout.dart';
import 'package:personal_budget/layout/menu_list.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

/// Displays detailed information about a SampleItem.
class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

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
            GFAvatar(
              size: 100,
              backgroundColor: GFColors.TRANSPARENT,
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
    await provider
        .signInWithGoogle()
        .then((value) => _homeNavigation(context, value));
  }

  Widget _singInSignOut(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    if (!provider.isLogged()) {
      return SignInButton(Buttons.Google,
          text: "Ingresar con Google",
          onPressed: () => _signInAndRedirect(context));
    }
    return GFButton(
      color: GFColors.DANGER,
      shape: GFButtonShape.pills,
      icon: const Icon(Icons.logout),
      onPressed: () =>
          provider.signout().then((value) => _loginNavigation(context)),
      text: "Desconectarse",
    );
  }

  _homeNavigation(BuildContext context, UserCredential user) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ExpensesList()),
        (route) => false);
  }

  _loginNavigation(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false);
  }
}
