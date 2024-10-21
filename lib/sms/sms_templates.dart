import '../expenses/expense_type.dart';

const debitMessageOld =
    "Scotiabank Colpatria: Realizaste trans en |commerce| por |value| con tu tarjeta Debito Clasica|date| Linea";
const creditMessageOld =
    "Scotiabank Colpatria: Realizaste trans en |commerce| por |value| con tu tarjeta Visa Infinite|date| Linea";
const debitMessage =
    "Scotiabank Colpatria: Realizaste transaccion en |commerce| por |value| con tu tarjeta Debito Clasica |date|.";
const creditMessage =
    "Scotiabank Colpatria: Realizaste transaccion en |commerce| por |value| con tu tarjeta Visa Infinite |date|.";

const pseMessage =
    "SCOTIABANK COLPATRIA: Te notifica Pago |commerce| mediante tu Banca Online por |value| desde tu Cta Ahorros el |date|.";
const transferAppMessage =
    "SCOTIABANK COLPATRIA: Te notifica |commerce| mediante APP por |value| desde tu Cta Ahorros el |date|Linea";

const appMessage =
    "SCOTIABANK COLPATRIA: Te notifica  mediante |commerce| por |value| desde tu Cta Ahorros el |date|Linea";
const creditRecurrentMessage =
    "Scotiabank Colpatria: Compra recurrente en |commerce| por |value| con tu tarjeta Visa Infinite |date| Linea";
const debitRecurrentMessage =
    "Scotiabank Colpatria: Compra recurrente en |commerce| por |value| con tu tarjeta Debito Clasica |date| Linea";

const withdrawal =
    "Scotiabank Colpatria: Realizaste trans en |commerce| por |value| con tu tarjeta Clasica|date| Linea";

class SmsTypeTemplate {
  ExpenseType type;
  String template;
  SmsTypeTemplate(this.type, this.template);
}

var availableTypes = {
  SmsTypeTemplate(ExpenseType.debitCard, debitMessageOld),
  SmsTypeTemplate(ExpenseType.creditCard, creditMessageOld),
  SmsTypeTemplate(ExpenseType.debitCard, debitMessage),
  SmsTypeTemplate(ExpenseType.creditCard, creditMessage),
  SmsTypeTemplate(ExpenseType.debitCard, debitRecurrentMessage),
  SmsTypeTemplate(ExpenseType.creditCard, creditRecurrentMessage),
  SmsTypeTemplate(ExpenseType.pse, pseMessage),
  SmsTypeTemplate(ExpenseType.app, appMessage),
  SmsTypeTemplate(ExpenseType.app, transferAppMessage),
  SmsTypeTemplate(ExpenseType.withdrawal, withdrawal)
};
