import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/layout/menu_option.dart';

import 'menu_list.dart';

class Layout extends StatelessWidget {
  const Layout(
      {Key? key,
      required this.id,
      required this.title,
      this.actions,
      required this.body,
      this.floatingActionButton})
      : super(key: key);

  final MenuList id;
  final Widget body;
  final List<Widget>? actions;
  final String title;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: GFColors.PRIMARY,
        title: Text(title),
        actions: actions,
      ),
      drawer: GFDrawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const GFDrawerHeader(
                decoration: BoxDecoration(color: GFColors.PRIMARY),
                centerAlign: true,
                currentAccountPicture: GFAvatar(
                  backgroundColor: GFColors.FOCUS,
                  backgroundImage: AssetImage('assets/icon.png'),
                ),
                child: GFListTile(
                  titleText: 'Personal Budget',
                  subTitleText: 'Controla tus gastos',
                  listItemTextColor: GFColors.LIGHT,
                )),
            MenuOption(option: MenuList.budget, selectedId: id),
            MenuOption(option: MenuList.cycle, selectedId: id),
            MenuOption(option: MenuList.charts, selectedId: id),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
