import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GFLoader(
      type: GFLoaderType.circle,
      size: 150,
    );
  }
}
