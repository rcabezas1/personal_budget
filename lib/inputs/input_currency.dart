import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/size/gf_size.dart';

import '../formats.dart';

class InputCurrency extends StatelessWidget {
  const InputCurrency(
      {Key? key,
      required this.value,
      required this.setValue,
      required this.hintText,
      this.size})
      : super(key: key);

  final double? value;
  final AsyncValueSetter<double?> setValue;
  final String? hintText;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [currencyInputTextFormatter],
      initialValue: _valueInitial(),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: size ?? GFSize.MEDIUM),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: size ?? GFSize.MEDIUM)),
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
      return currencyInputTextFormatter.format('${value!.toInt()}');
    }
    return "";
  }
}
