enum BudgetType { debitCard, creditCard, pse, cash, app }

extension BudgetTypeExt on BudgetType {
  String get print {
    switch (this) {
      case BudgetType.debitCard:
        return "Tarjeta Debito";
      case BudgetType.creditCard:
        return "Tarjeta Credito";
      case BudgetType.app:
        return "App";
      case BudgetType.pse:
        return "PSE";
      case BudgetType.cash:
        return "Efectivo";
      default:
        return "";
    }
  }

  String get nameType {
    return toString().split(".").last;
  }
}
