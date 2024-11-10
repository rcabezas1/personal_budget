import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        //searchBar: searchBar ?? false,
        //searchHintText: "Buscar",
        //searchController: searchController,
        foregroundColor: Colors.white,
        title: titleWidget ??
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
        titleTextStyle: TextStyle(color: Colors.white),
        actions: actions,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          children: _getMenuOptions(),
        ),
      ),
      body: body,
      persistentFooterButtons: footer,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _getTitle() {
    return const ListTile(
      trailing: Image(image: AssetImage("assets/icon.png")),
      title: Text("Personal Budget"),
      selected: true,
      contentPadding: EdgeInsets.all(20),
      selectedTileColor: Colors.blueAccent,
      selectedColor: Colors.white,
    );
  }

  Widget _getAvatar() {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 10),
        CircleAvatar(
          backgroundColor: Colors.amber,
          radius: 50,
          backgroundImage: _getBackGroundImage(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  List<Widget> _getMenuOptions() {
    var avatar = _getAvatar();
    var title = _getTitle();
    if (FirebaseAuth.instance.currentUser != null) {
      return [
        title,
        avatar,
        MenuOption(option: MenuList.expense, selectedId: id),
        MenuOption(option: MenuList.cycle, selectedId: id),
        MenuOption(option: MenuList.charts, selectedId: id),
        MenuOption(option: MenuList.plan, selectedId: id),
        MenuOption(option: MenuList.login, selectedId: id)
      ];
    }
    return [title, MenuOption(option: MenuList.login, selectedId: id)];
  }

  _getBackGroundImage() {
    return FirebaseAuth.instance.currentUser != null
        ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
        : const AssetImage("assets/icon.png");
  }
}
