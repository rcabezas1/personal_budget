import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/layout/menu_option.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'menu_list.dart';

class Layout extends StatelessWidget {
  const Layout(
      {Key? key,
      required this.id,
      required this.title,
      this.actions,
      required this.body,
      this.floatingActionButton,
      this.searchBar,
      this.searchController})
      : super(key: key);

  final MenuList id;
  final Widget body;
  final List<Widget>? actions;
  final String title;
  final Widget? floatingActionButton;
  final bool? searchBar;
  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: GFColors.PRIMARY,
        searchBar: searchBar ?? false,
        searchHintText: "Buscar",
        searchController: searchController,
        title: Text(title),
        actions: actions,
      ),
      drawer: GFDrawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GFDrawerHeader(
                decoration: const BoxDecoration(color: GFColors.PRIMARY),
                centerAlign: true,
                currentAccountPicture: GFAvatar(
                  backgroundColor: GFColors.FOCUS,
                  backgroundImage: _getBackGroundImage(),
                ),
                child: GFListTile(
                  titleText: 'Personal Budget',
                  subTitleText:
                      FirebaseAuth.instance.currentUser?.displayName ??
                          'Presupuesto Gastos',
                  listItemTextColor: GFColors.LIGHT,
                )),
            MenuOption(option: MenuList.login, selectedId: id),
            MenuOption(option: MenuList.expense, selectedId: id),
            MenuOption(option: MenuList.cycle, selectedId: id),
            MenuOption(option: MenuList.charts, selectedId: id),
            MenuOption(option: MenuList.plan, selectedId: id),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  _getBackGroundImage() {
    return FirebaseAuth.instance.currentUser != null
        ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
        : const AssetImage("assets/icon.png");
  }
}
