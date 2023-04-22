import '../expenses/expense_type.dart';

const debitMessage =
    "Scotiabank Colpatria: Realizaste trans en |commerce| por |value| con tu tarjeta Debito Clasica|date| Linea";
const creditMessage =
    "Scotiabank Colpatria: Realizaste trans en |commerce| por |value| con tu tarjeta Visa Infinite|date| Linea";
const pseMessage =
    "SCOTIABANK COLPATRIA: Te notifica Pago |commerce| mediante tu Banca Online por |value| desde tu Cta Ahorros el |date|Linea";
const appMessage =
    "SCOTIABANK COLPATRIA: Te notifica  mediante |commerce| por |value| desde tu Cta Ahorros el |date|Linea";

class SmsTypeTemplate {
  ExpenseType type;
  String template;
  SmsTypeTemplate(this.type, this.template);
}

var availableTypes = {
  SmsTypeTemplate(ExpenseType.debitCard, debitMessage),
  SmsTypeTemplate(ExpenseType.creditCard, creditMessage),
  SmsTypeTemplate(ExpenseType.pse, pseMessage),
  SmsTypeTemplate(ExpenseType.app, appMessage)
};
