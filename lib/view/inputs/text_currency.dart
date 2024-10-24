import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/size/gf_size.dart';

import 'formats.dart';

class TextCurrency extends StatelessWidget {
  const TextCurrency({super.key, required this.value, this.size, this.onTap});

  final double value;
  final double? size;
  final AsyncCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '\$${currencyFormat.format(value)}',
      onTap: onTap,
      style: TextStyle(fontSize: size ?? GFSize.MEDIUM),
    );
  }
}
