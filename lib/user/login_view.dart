import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
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
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    return Layout(
        id: MenuList.login,
        title: "Login",
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            Text(
              "Iniciar Sesión",
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            const SizedBox(height: 50),
            SignInButton(Buttons.Google,
                text: "Iniciar sesion con Google",
                onPressed: () async => (await provider.signInWithGoogle()))
          ],
        ))));
  }
}
