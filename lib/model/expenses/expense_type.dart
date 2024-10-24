enum ExpenseType { debitCard, creditCard, pse, cash, app, withdrawal }

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
      case ExpenseType.withdrawal:
        return "Cajero";
    }
  }

  String get nameType {
    return toString().split(".").last;
  }
}
