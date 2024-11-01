import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'formats.dart';

class TextCurrency extends StatelessWidget {
  const TextCurrency({super.key, required this.value, this.size, this.onTap});

  final double value;
  final double? size;
  final AsyncCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '\$${currencyFormat.format(value)}'.trim(),
      onTap: onTap,
      enableInteractiveSelection: false,
      style: TextStyle(fontSize: size ?? 35),
      readOnly: true,
    );
  }
}
