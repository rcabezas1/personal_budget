import 'package:flutter/material.dart';
import 'package:getwidget/size/gf_size.dart';

import '../formats.dart';

class TextCurrency extends StatelessWidget {
  const TextCurrency({Key? key, this.value, this.size}) : super(key: key);

  final double? value;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${value != null ? currencyFormat.format(value) : ""}',
      style: TextStyle(fontSize: size ?? GFSize.MEDIUM),
    );
  }
}
