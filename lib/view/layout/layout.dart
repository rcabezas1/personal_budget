import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import './menu_option.dart';

import 'menu_list.dart';

class Layout extends StatelessWidget {
  const Layout(
      {super.key,
      required this.id,
      required this.title,
      this.titleWidget,
      this.actions,
      required this.body,
      this.footer,
      this.floatingActionButton,
      this.searchBar,
      this.searchController});

  final MenuList id;
  final Widget body;
  final List<Widget>? footer;
  final List<Widget>? actions;
  final String title;
  final Widget? titleWidget;
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
        title: titleWidget ?? Text(title),
        actions: actions,
      ),
      drawer: GFDrawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: _getMenuOptions(),
        ),
      ),
      body: body,
      persistentFooterButtons: footer,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _getHeader() {
    return GFDrawerHeader(
        decoration: const BoxDecoration(color: GFColors.PRIMARY),
        centerAlign: true,
        currentAccountPicture: GFAvatar(
          backgroundColor: GFColors.FOCUS,
          backgroundImage: _getBackGroundImage(),
        ),
        child: GFListTile(
          titleText: 'Personal Budget',
          subTitleText: FirebaseAuth.instance.currentUser?.displayName ??
              'Presupuesto Gastos',
          listItemTextColor: GFColors.LIGHT,
        ));
  }

  List<Widget> _getMenuOptions() {
    var header = _getHeader();
    if (FirebaseAuth.instance.currentUser != null) {
      return [
        header,
        MenuOption(option: MenuList.expense, selectedId: id),
        MenuOption(option: MenuList.cycle, selectedId: id),
        MenuOption(option: MenuList.charts, selectedId: id),
        MenuOption(option: MenuList.plan, selectedId: id),
        MenuOption(option: MenuList.login, selectedId: id)
      ];
    }
    return [header, MenuOption(option: MenuList.login, selectedId: id)];
  }

  _getBackGroundImage() {
    return FirebaseAuth.instance.currentUser != null
        ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
        : const AssetImage("assets/icon.png");
  }
}
