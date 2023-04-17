class BudgetCycleUpdate {
  String cycle;
  bool valid;
  BudgetCycleUpdate(this.cycle, this.valid);

  Map<String, dynamic> toJson() => {'cycle': cycle, 'valid': valid};
}
