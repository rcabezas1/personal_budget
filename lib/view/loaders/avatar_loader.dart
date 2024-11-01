import 'package:flutter/material.dart';

class AvatarLoader extends StatelessWidget {
  const AvatarLoader(
      {super.key, required this.saving, required this.avatar, this.size});

  final bool saving;
  final String avatar;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return saving
        ? const CircleAvatar(
            backgroundImage: AssetImage('assets/loading.gif'),
            radius: 20,
          )
        : CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            backgroundImage: AssetImage('assets/$avatar.png'),
          );
  }
}
