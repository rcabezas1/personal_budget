import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AvatarLoader extends StatelessWidget {
  const AvatarLoader(
      {Key? key, required this.saving, required this.avatar, this.size})
      : super(key: key);

  final bool saving;
  final String avatar;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return saving
        ? const GFLoader(
            type: GFLoaderType.circle,
            loaderColorOne: GFColors.INFO,
            loaderColorTwo: GFColors.PRIMARY,
            loaderColorThree: GFColors.INFO,
          )
        : GFAvatar(
            backgroundColor: GFColors.LIGHT,
            size: size ?? GFSize.MEDIUM,
            backgroundImage: AssetImage('assets/$avatar.png'),
          );
  }
}
