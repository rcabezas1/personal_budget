import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'formats.dart';

class InputCurrency extends StatelessWidget {
  const InputCurrency(
      {super.key,
      required this.value,
      required this.setValue,
      required this.hintText,
      this.size,
      this.onTap});

  final double? value;
  final AsyncValueSetter<double?> setValue;
  final AsyncCallback? onTap;
  final String? hintText;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [currencyInputTextFormatter],
      initialValue: _valueInitial(),
      keyboardType: TextInputType.number,
      onTap: onTap,
      style: TextStyle(fontSize: size ?? 35),
      decoration: InputDecoration(
          hintText: hintText, hintStyle: TextStyle(fontSize: size ?? 35)),
      onChanged: _setValue,
    );
  }

  _setValue(String value) {
    if (currencyInputTextFormatter.getUnformattedValue().isNaN) {
      setValue(null);
    } else {
      setValue(currencyInputTextFormatter.getUnformattedValue().toDouble());
    }
  }

  _valueInitial() {
    if (value != null) {
      return currencyInputTextFormatter.formatString('${value!.toInt()}');
    }
    return "";
  }
}
