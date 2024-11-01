import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
final currencyFormat = NumberFormat.currency(
  symbol: "",
  decimalDigits: 0,
  locale: "es-CO",
);
final currencyInputTextFormatter = CurrencyTextInputFormatter(currencyFormat);
