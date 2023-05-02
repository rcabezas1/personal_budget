enum ExpenseType { debitCard, creditCard, pse, cash, app }

extension ExpenseTypeExt on ExpenseType {
  String get print {
    switch (this) {
      case ExpenseType.debitCard:
        return "Tarjeta Debito";
      case ExpenseType.creditCard:
        return "Tarjeta Credito";
      case ExpenseType.app:
        return "App";
      case ExpenseType.pse:
        return "PSE";
      case ExpenseType.cash:
        return "Efectivo";
      default:
        return "";
    }
  }

  String get nameType {
    return toString().split(".").last;
  }
}
