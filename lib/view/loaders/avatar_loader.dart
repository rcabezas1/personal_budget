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
        ? CircleAvatar(
            backgroundImage: AssetImage('assets/loading.gif'),
            radius: size ?? 30,
          )
        : CircleAvatar(
            backgroundColor: Colors.white,
            radius: size ?? 30,
            backgroundImage: AssetImage('assets/$avatar.png'),
          );
  }
}
