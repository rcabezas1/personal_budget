import 'package:flutter/material.dart';
import 'package:personal_budget/model/expenses/expense.dart';
import 'package:personal_budget/service/storage/memory_storage.dart';
import 'package:personal_budget/view/expenses/expense_card.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Agregar Gasto',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          restorationId: "manual",
          child: ExpenseCard(
            expense: Expense.manual("cash${const Uuid().v4()}",
                MemoryStorage.instance.userData?.fuid ?? ""),
            input: true,
          ),
        ));
  }
}
