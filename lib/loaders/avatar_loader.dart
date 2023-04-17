import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

class AvatarLoader extends StatelessWidget {
  const AvatarLoader({Key? key, required this.saving, required this.avatar})
      : super(key: key);

  final bool saving;
  final String avatar;

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
            backgroundImage: AssetImage('assets/$avatar.png'),
          );
  }
}
